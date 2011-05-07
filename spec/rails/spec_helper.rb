ENV['RAILS_ENV'] = 'production'

require './spec/rails/rails_app/config/environment'

include Rack::Test::Methods

def app
  Rails.application
end

RSpec.configure do |config|
  config.after do
    Count.collection.remove
    clear_cookies
  end
end

Count.collection.drop

def assigned_count_id
  last_response.headers['count_id'].to_i
end
