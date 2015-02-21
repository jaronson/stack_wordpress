require 'puppet'
require 'facter'
require 'json'
require 'socket'

begin
  require 'puppetdb'
  Stack::FactProvider.new.add_facts
rescue LoadError => e
  Stack::Log.logger.warn('Missing puppetdb-ruby gem. This should be present on the next agent run')
end
