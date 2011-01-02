ENV["RAILS_ENV"] = "test"

require 'rails_app/config/environment'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

include Rack::Test::Methods

def app
  Rails.application
end

RSpec.configure do |config|
  config.after do
    clear_cookies
    Mingo.collection.remove
  end
end

Mingo.collection.remove
