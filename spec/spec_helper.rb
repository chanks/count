require 'count'

Count.collection = Mongo::Connection.new['count_test']['results']

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

# Require shared example groups before running any specs
Dir["#{File.dirname(__FILE__)}/**/shared/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.after { Count.collection.remove }
end

Count.collection.drop
