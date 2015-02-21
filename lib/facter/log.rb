require 'logger'

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
end
