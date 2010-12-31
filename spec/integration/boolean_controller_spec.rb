require 'spec_helper'

describe "A controller action with a boolean a/b test" do
  before do
    get '/booleans/test'
  end

  it "should return true or false, not both" do
    %w(true false).should include last_response.body
  end
end
