require 'spec_helper'

describe "A controller action with a boolean a/b test" do
  def result
    get '/booleans/test'
    last_response.body
  end

  it "should return true or false for different users" do
    results = (1..10).map { clear_cookies; result }
    results.uniq.sort.should == %w(false true)
  end

  it "should always return either true or false for a given user" do
    (1..10).map{ result }.uniq.count.should == 1
  end
end
