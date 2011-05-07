require 'singleton'
require 'digest/md5'

require 'mongo'

require 'count/alternative'
require 'count/config'
require 'count/helpers'
require 'count/test'
require 'count/version'

if defined? Rails::Railtie
  require 'count/rails_count_id'
  require 'count/railtie'
end

module Count
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
