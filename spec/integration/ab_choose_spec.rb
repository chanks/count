require 'spec_helper'

# Spec the basic behavior of the ab_choose helper, with and without a block.

%w(array array_block).each do |type|
  describe "An A/B #{type} choose helper" do
    define_method :choose! do
      get "/controller_tests/#{type}_choose"
      eval(last_response.body)
    end

    def convert!
      get "/controller_tests/array_bingo"
    end

    it "should always return the same value for a given user" do
      (1..10).map{ choose! }.uniq.count.should == 1
    end

    it "should return 1, 2, and 3 each approximately 33% of the time (this will fail occasionally)" do
      results = Hash.new(0)
      100.times { clear_cookies; results[choose!] += 1 }

      results.keys.sort.should == [1, 2, 3]
      results.values.each { |value| value.should be_within(15).of(33) }
    end

    context "that returns a value for a user" do
      before { choose! }

      it "should not insert anything into the db" do
        Mingo.collection.count.should == 0
      end

      context "who then converts" do
        before { convert! }

        it "should not insert anything into the db" do
          Mingo.collection.count.should == 0
        end
      end
    end

    context "for a test that already has participations/conversions for other users" do
      before do
        populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      end

      def results_for(number)
        Mingo.collection.find_one :test => 'array', :alternative => number
      end

      context "and returns a value for a user" do
        before { @number = choose! }

        it "should not mark that user as a participant in the db" do
          results_for(@number)['participants'].should_not include assigned_mingo_id
        end

        context "who then converts" do
          before { convert! }

          it "should not be recorded as a participant or conversion" do
            record = results_for(@number)
            record['participants'].should_not include assigned_mingo_id
            record['conversions'].should_not include assigned_mingo_id
          end
        end
      end
    end
  end
end
