require 'spec_helper'

describe "A controller action with a boolean a/b test" do
  def result
    get '/booleans/test'
    last_response.body
  end

  it "should return true and false each approximately 50% of the time" do
    results = (1..100).map { clear_cookies; result }

    %w(true false).each do |possibility|
      results.select{|s| s == possibility}.count.should be_within(10).of(50)
    end
  end

  it "should always return either true or false for a given user" do
    (1..10).map{ result }.uniq.count.should == 1
  end
end
