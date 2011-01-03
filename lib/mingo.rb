require 'singleton'
require 'digest/md5'

require 'mongo'

require 'active_support/core_ext/module/delegation'

require 'mingo/alternative'
require 'mingo/config'
require 'mingo/helpers'
require 'mingo/test'
require 'mingo/version'

if defined? Rails
  require 'mingo/rails_mingo_id'
  require 'mingo/engine'
end

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
