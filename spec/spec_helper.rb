ENV["RAILS_ENV"] = "test"

require 'rails_app/config/environment'

include Rack::Test::Methods

def app
  Rails.application
end
