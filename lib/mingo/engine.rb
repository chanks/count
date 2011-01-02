module Mingo
  class Engine < Rails::Engine
    initializer "mingo.helpers" do
      [:action_view, :action_controller].each do |hook|
        ActiveSupport.on_load(hook){ include Mingo::Helpers }
      end
    end

    rake_tasks do
      load 'mingo/tasks.rb'
    end
  end
end
