require 'spec_helper'

branch :test, :choose do |helper_type|
  describe "An A/B array choose helper used as a block" do

    # Hits the appropriate helper as a block, returns its value.
    define_method :trigger! do
      get "/controller_tests/array_#{helper_type}_block"
      eval(last_response.body)
    end

    it "should always return the same value for a given user" do
      (1..10).map{ trigger! }.uniq.count.should == 1
    end

    it "should return a value of 1, 2 or 3" do
      [1, 2, 3].should include trigger!
    end

    it "should return each value approximately 33% of the time" do
      results = Hash.new(0)
      100.times { clear_cookies; results[trigger!] += 1 }
      results.values.each { |value| value.should be_within(15).of(33) }
    end

    context "that returns a value for a user" do
      before { @alternative = trigger! }

      if helper_type.test?
        it "should mark the user as a participant" do
          record = Mingo.collection.find_one(:alternative => @alternative)
          record['participants'].should include mingo_id
        end
      end

      if helper_type.choose?
        it "should not insert anything into the db" do
          Mingo.collection.count.should == 0
        end
      end
    end
  end
end
