require 'spec_helper'

describe "When Mingo doesn't have a collection set" do

  before { @collection, Mingo.collection = Mingo.collection, nil }
  after  { Mingo.collection = @collection }

  def participate!
    get "/controller_tests/array"
    eval(last_response.body)
  end

  it "it will always return the same value for a given user, but won't persist any information" do
    (1..10).map{ participate! }.uniq.count.should == 1
    @collection.count.should == 0
  end

  it "will return each value approximately 33% of the time, but won't persist any information (this will fail occasionally)" do
    results = Hash.new(0)
    100.times { clear_cookies; results[participate!] += 1 }
    results.values.each { |value| value.should be_within(15).of(33) }
    @collection.count.should == 0
  end
end
