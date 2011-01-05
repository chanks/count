ENV['RAILS_ENV'] = 'production'

require './spec/rails/rails_app/config/environment'

include Rack::Test::Methods

def app
  Rails.application
end

RSpec.configure do |config|
  config.after do
    Mingo.collection.remove
    clear_cookies
  end
end

Mingo.collection.drop

def assigned_mingo_id
  last_response.headers['mingo_id'].to_i
end
