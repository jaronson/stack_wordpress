module Stack
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

    def add_facts
      add_app_facts
      add_db_facts
    end

    def add_app_facts
      app_facts = []
      nodes     = find_nodes("^#{stack_name}-app.*")

      nodes.each do |node|

        fact_name = "#{node['name'].split('-').last}-ip"
        facts     = find_facts(node['name'])

        facts.each do |fact|
          value = fact['value']

          Log.logger.info("Adding fact: #{fact_name} = #{value}")
          app_facts << "#{fact_name}=#{value}"
        end
      end

      Facter.add(:stack_apps) do
        setcode do
          app_facts.join(',')
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
