require 'mongo'

require 'mingo/alternative'
require 'mingo/config'
require 'mingo/engine'
require 'mingo/experiment'
require 'mingo/helpers'
require 'mingo/version'

module Mingo
  class << self
    def configure
      config = Config.instance
      yield config if block_given?
      config
    end
    alias :config :configure

    Config.public_instance_methods(false).each { |method| delegate method, :to => :configure }
  end
end
