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

    def fact_names
      [
        :ec2_public_ipv4,
        :ec2_public_hostname,
      ]
    end

    def find_nodes
      api.client.request('nodes', [ :~, 'name', "^#{stack_name}.*" ]).data
    end

    def find_facts(node_name)
      api.client.request("facts", [ :'=', "certname", node_name ]).data
    end

    def add_facts
      nodes = find_nodes

      Log.logger.info(nodes)

      nodes.each do |node|
        type = node['name'].split('-').last

        facts = find_facts(node['name'])

        facts.each do |fact|
          next unless fact_names.include?(fact['name'].to_sym)

          fact_name = "#{type}_#{fact['name']}".to_sym
          value     = fact['value']

          Log.logger.info("Setting fact: #{fact_name} = #{value}")

          Facter.add(fact_name) do
            setcode do
              value
            end
          end
        end
      end
    end
  end
end
