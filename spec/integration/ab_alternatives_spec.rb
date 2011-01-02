require 'spec_helper'

# Spec the various types of alternatives that the ab_test helper can accept.

branch :array, :boolean, :range, :hash, :integer do |test_type|
  describe "An A/B #{test_type} test" do
    define_method :participate! do
      get "/controller_tests/#{test_type}"
      eval(last_response.body)
    end

    define_method :convert! do
      get "/controller_tests/#{test_type}_bingo"
    end

    define_method :results_for do |alternative|
      Mingo.collection.find_one :test => "#{test_type}_test", :alternative => alternative
    end

    it "should always return the same value for a given user" do
      (1..10).map{ participate! }.uniq.count.should == 1
    end

    if test_type.boolean?
      it "should return true and false each approximately 50% of the time" do
        results = Hash.new(0)
        100.times { clear_cookies; results[participate!] += 1 }
        [[true, false], [false, true]].should include results.keys # can't sort - awkward
        results.values.each { |value| value.should be_within(15).of(50) }
      end
    end

    if test_type.array? || test_type.range? || test_type.integer?
      it "should return 1, 2 and 3 each approximately 33% of the time" do
        results = Hash.new(0)
        100.times { clear_cookies; results[participate!] += 1 }
        results.keys.sort.should == [1, 2, 3]
        results.values.each { |value| value.should be_within(15).of(33) }
      end
    end

    if test_type.hash?
      it "should return 1 ~66% of the time and 2 ~33% of the time" do
        results = Hash.new(0)
        100.times { clear_cookies; results[participate!] += 1 }

        results.keys.sort.should == [1, 2]

        results[1].should be_within(15).of(66)
        results[2].should be_within(15).of(33)
      end
    end
  end
end
