require 'spec_helper'

# Spec the basic participation/conversion behavior of the ab_test / bingo! helpers.

describe "An A/B test" do
  def participate!
    get "/controller_tests/array"
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

    it "several times should not create any duplicate result records" do
      3.times { participate! }
      Mingo.collection.count.should == 1
      results_for(@number)['_id'].should == "array/#{@number}"
    end

    context "who then converts" do
      before { convert! }

      it "should be recorded as a conversion" do
        record = results_for(@number)

        record['participant_count'].should == 1
        record['participants'].should      == [mingo_id]
        record['conversion_count'].should  == 1
        record['conversions'].should       == [mingo_id]
      end

      it "several times should be recorded as a conversion only once" do
        3.times { convert! }
        record = results_for(@number)

        record['participant_count'].should == 1
        record['participants'].should == [mingo_id]
        record['conversion_count'].should == 1
        record['conversions'].should == [mingo_id]
      end
    end
  end

  # Upserts bite me every once in a while, so I like to make sure
  # the behavior stays the same whether or not the record is already there.
  context "that has already recorded participations/conversions for some users" do
    before do
      10.times do |i|
        participate!
        convert! if i.even?
        clear_cookies
      end
    end

    it "that has a conversion for a user that hasn't participated should not record it" do
      convert!

      Mingo.collection.find.to_a.each do |record|
        record['participants'].should_not include mingo_id

        # conversions were chosen randomly, so not all records will have that field.
        if conversions = record['conversions']
          conversions.should_not include mingo_id
        end
      end
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

      context "who then converts" do
        before { convert! }

        it "should be recorded as a conversion" do
          record = results_for(@number)

          record['participants'].should include mingo_id
          record['conversions'].should include mingo_id
        end

        it "several times should be recorded as a conversion only once" do
          3.times { convert! }

          results_for(@number)['conversions'].select{ |p| p == mingo_id }.count.should == 1
        end
      end
    end
  end
end
