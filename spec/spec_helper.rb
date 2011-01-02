ENV["RAILS_ENV"] = "production"

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

Mingo.collection.drop

# Helper to run a set of specs several times under different conditions.
def branch(*args, &block)
  args.map { |sym| ActiveSupport::StringInquirer.new sym.to_s }.each(&block)
end

def mingo_id
  last_response.headers['mingo_id'].to_i
end

def populate(hash)
  hash[:alternatives].each do |alternative, (participant_count, conversion_count)|
    doc = { :test              => hash[:test],
            :alternative       => alternative,
            :participant_count => participant_count,
            :participants      => (1..20).map{rand(2**31)},
            :conversion_count  => conversion_count,
            :conversions       => (1..20).map{rand(2**31)} }

    Mingo.collection.insert(doc)
  end
end
