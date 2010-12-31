require 'spec_helper'

describe "A user visiting a page with a boolean a/b test" do
  def result
    get '/view_tests/test/boolean'
    last_response.body.strip
  end

  it "should see true or false for different users" do
    results = (1..10).map { result }
    results.uniq.sort.should == %w(false true)
  end
end
