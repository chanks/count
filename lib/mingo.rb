require 'singleton'
require 'digest/md5'

require 'mongo'

require 'mingo/alternative'
require 'mingo/config'
require 'mingo/helpers'
require 'mingo/test'
require 'mingo/version'

if defined? Rails
  require 'mingo/rails_mingo_id'
  require 'mingo/railtie'
end

module Mingo
  class << self
    def configure
      config = Config.instance
      yield config if block_given?
      config
    end
    alias :config :configure

    Config.public_instance_methods(false).each do |method|
      class_eval <<-METHOD
        def #{method}(*args)
          configure.send("#{method}", *args)
        end
      METHOD
    end
  end
end
