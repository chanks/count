module Mingo
  class Railtie < Rails::Railtie
    config.mingo = ::Mingo::Config.instance

    initializer "mingo.helpers" do
      [:action_view, :action_controller].each do |hook|
        ActiveSupport.on_load hook do
          include Mingo::RailsMingoId
          include Mingo::Helpers
        end
      end
    end

    rake_tasks do
      load 'mingo/tasks.rb'
    end
  end
end