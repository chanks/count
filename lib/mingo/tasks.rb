namespace :mingo do
  desc "Display the results of the current tests."
  task :results => :environment do
    Mingo::Test.all.each do |test|
      puts '*' * 50
      puts "Results for test '#{test.id}':"
      puts
      puts test.results
    end
  end

  desc "Clear all test data."
  task :clear => :environment do
    Mingo.collection.remove
  end
end
