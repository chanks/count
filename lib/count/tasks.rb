namespace :count do
  desc "Display the results of the current tests."
  task :results => :environment do
    Count::Test.all.each do |test|
      puts '*' * 50
      puts "Results for test '#{test.id}':"
      puts
      puts test.results
    end
  end

  desc "List all tests that have collected results."
  task :list => :environment do
    Count::Test.all.each { |test| puts test.id }
  end

  desc "Clear all test data."
  task :clear => :environment do
    Count.collection.remove
  end

  desc "Create an index to help the database with large result sets."
  task :index => :environment do
    Count.index!
  end
end
