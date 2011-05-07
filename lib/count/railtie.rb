module Count
  class Railtie < Rails::Railtie
    config.count = ::Count::Config.instance

    initializer "count.helpers" do
      [:action_view, :action_controller].each do |hook|
        ActiveSupport.on_load hook do
          include Count::RailsCountId
          include Count::Helpers
        end
      end
    end

    rake_tasks do
      load 'count/tasks.rb'
    end
  end
end
