require 'spec_helper'

# Spec the basic participation/conversion behavior of the ab_test / bingo! helpers.
# Runs twice - once for ab_test with a block, once without.

%w(array array_block).each do |type|
  describe "An A/B #{type} test" do
    define_method :participate! do
      get "/controller_tests/#{type}"
      eval(last_response.body)
    end

    def convert!
      get "/controller_tests/array_bingo"
    end

    def results_for(alternative)
      Mingo.collection.find_one :test => 'array', :alternative => alternative
    end

    it "that has a conversion for a user that hasn't participated should not record it" do
      convert!
      Mingo.collection.count.should == 0
    end

    context "that returns a value for a user" do
      before { @number = participate! }

      it "should mark that user as a participant in the db" do
        record = results_for(@number)

        record['participant_count'].should == 1
        record['participants'].should      == [mingo_id]
      end

      it "several times should mark that user as a participant only once" do
        3.times { participate! }
        record = results_for(@number)

        record['participant_count'].should == 1
        record['participants'].should      == [mingo_id]
      end

      it "several times should not create any duplicate inserts, thanks to the unique _id index" do
        3.times { participate! }
        Mingo.collection.count.should == 1
        results_for(@number)['_id'].should == "array/#{@number}"
      end
    end

    # Upserts bite me every once in a while, so I like to make sure
    # the behavior stays the same whether or not the record is already there.
    context "that has already recorded participations/conversions for some users" do
      before do
        populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      end

      context "and returns a value for a user" do
        before { @number = participate! }

        it "should mark that user as a participant in the db" do
          results_for(@number)['participants'].should include mingo_id
        end

        it "several times should mark that user as a participant only once" do
          3.times { participate! }

          results_for(@number)['participants'].select{ |p| p == mingo_id }.count.should == 1
        end
      end
    end
  end
end
