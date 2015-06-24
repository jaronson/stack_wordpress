require 'logger'
require 'puppet'
require 'facter'
require 'json'
require 'socket'
require 'json'

module Stack
  class Log
    @logger = nil

    def self.logger
      return @logger if @logger

      @logger = Logger.new(logpath)
    end

    def self.logpath
      '/tmp/stack.log'
    end
  end

  class Config
    attr_reader :node, :port, :server,
      :ca_path, :cert_path, :key_path

    def initialize
      unless Puppet.settings.global_defaults_initialized?
        Puppet.initialize_settings
      end

      @server    = Puppet.settings.value('server')
      @ca_path   = Puppet.settings.value('localcacert')
      @cert_path = Puppet.settings.value('hostcert')
      @key_path  = Puppet.settings.value('hostprivkey')
      @node      = Socket.gethostname
      @port      = 8081
    end
  end

  class Api
    attr_reader :client, :config

    def initialize
      @config = Config.new
      @client = PuppetDB::Client.new({
        :server => endpoint,
        :pem    => {
          'key' => config.key_path,
          'cert' => config.cert_path,
          'ca_file' => config.ca_path
        }
      })
    end

    def endpoint
      "https://#{config.server}:#{config.port}"
    end
  end

  class FactProvider
    attr_reader :api, :config

    def initialize
      @api    = Api.new
      @config = Config.new
    end

    def stack_name
      config.node.split('-').first
    end

    def find_nodes(pattern)
      api.client.request('nodes', [ :~, 'name', pattern ]).data
    end

    def find_facts(node_name)
      api.client.request('facts', [
        :and,
        [ :'=', 'certname', node_name ],
        [ :'=', 'name', 'ec2_public_ipv4'],
      ]).data
    end

    def find_catalog(node_name)
      PuppetDB::Client.get("/catalogs/#{node_name}").parsed_response
    end

    def add_facts
      add_app_facts
      add_db_facts
    end

    def add_my_ip(address)
      Facter.add(:public_ip_address) do
        setcode do
          address
        end
      end
    end

    def add_app_facts
      apps  = []
      nodes = find_nodes("^#{stack_name}-web*")

      nodes.each do |node|
        node_name = node['name']
        node_ip   = find_facts(node_name).first['value']
        add_my_ip(node_ip)

        catalog   = find_catalog(node_name)

        apps << {
          'name' => node_name,
          'public_ip' => node_ip,
          'catalog' => catalog,
        }
      end

      Log.logger.info("Apps: #{apps.inspect}")

      Facter.add(:stack_apps) do
        setcode do
          JSON.dump(apps)
        end
      end
    end

    def add_db_facts
      node = find_nodes("^#{stack_name}-db").first
      fact = find_facts(node['name']).first

      Facter.add(:stack_db_ip) do
        setcode do
          fact['value']
        end
      end
    end
  end
end

begin
  require 'puppetdb'
  Stack::FactProvider.new.add_facts
rescue LoadError => e
  Stack::Log.logger.warn('Missing puppetdb-ruby gem. This should be present on the next agent run')
end
