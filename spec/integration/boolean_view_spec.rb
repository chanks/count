require 'spec_helper'

describe "A user visiting a page with a boolean a/b test" do
  def result
    get '/view_tests/test/boolean'
    last_response.body.strip
  end

  it "should see true or false for different users" do
    results = (1..10).map { clear_cookies; result }
    results.uniq.sort.should == %w(false true)
  end

  it "should always see either true or false for a given user" do
    (1..10).map{ result }.uniq.count.should == 1
  end
end
