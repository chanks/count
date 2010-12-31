require 'spec_helper'

describe "A user visiting a page with a boolean a/b test" do
  before do
    get '/view_tests/test/boolean'
  end

  it "should see either true or false, not both" do
    %w(true false).should include last_response.body.strip
  end
end
