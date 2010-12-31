ENV["RAILS_ENV"] = "test"

require 'rails_app/config/environment'

include Rack::Test::Methods

def app
  Rails.application
end

RSpec.configure do |config|
  config.after { clear_cookies }
end
