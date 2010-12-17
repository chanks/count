require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'mingo'

module RailsApp
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
