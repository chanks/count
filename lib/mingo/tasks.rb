namespace :mingo do
  desc "Display the results of the current experiments."
  task :results => :environment do
    Mingo::Experiment.parse_all.each do |experiment|
      puts '*' * 50
      puts "Results for test '#{experiment.id}':"
      puts
      puts experiment.results
    end
  end

  desc "Clear all experimental data."
  task :clear => :environment do
    Mingo.collection.remove
  end
end
