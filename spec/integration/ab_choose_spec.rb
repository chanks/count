require 'spec_helper'

describe "An A/B array choose helper" do

  # Hits an ab_choose helper, returns its value.
  define_method :choose! do
    get "/controller_tests/array_choose"
    eval(last_response.body)
  end

  # Hits an ab_test helper, returns its value.
  define_method :participate! do
    get "/controller_tests/array"
    eval(last_response.body)
  end

  # Trigger the conversion.
  define_method :convert! do
    get "/controller_tests/array_bingo"
  end

  define_method :results_for do |alternative|
    Mingo.collection.find_one :test => "array_test", :alternative => alternative
  end

  it "should always return the same value for a given user" do
    (1..10).map{ choose! }.uniq.count.should == 1
  end

  it "should return a value of 1, 2 or 3" do
    [1, 2, 3].should include participate!
  end

  it "should return each value approximately 33% of the time" do
    results = Hash.new(0)
    100.times { clear_cookies; results[participate!] += 1 }
    results.values.each { |value| value.should be_within(15).of(33) }
  end

  context "that returns a value for a user" do
    before { @alternative = choose! }

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

  # Upserts bite me every once in a while, so I like to make sure
  # the behavior stays the same whether or not the record is already there.
  context "for a test that already has participations/conversions for other users" do
    before do
      10.times do |i|
        participate!
        convert! if i.even?
        clear_cookies
      end
    end

    context "and returns a value for a user" do
      before { @alternative = choose! }

      # Since the user hasn't been marked as a participant/conversion,
      # these records and their fields may not exist. Hence, the ugly ifs.
      it "should not mark that user as a participant in the db" do
        if record = results_for(@alternative)
          if participants = record['participants']
            participants.should_not include mingo_id
          end
        end
      end

      context "who then converts" do
        before { convert! }

        it "should not be recorded as a participant or conversion" do
          if record = results_for(@alternative)
            if participants = record['participants']
              participants.should_not include mingo_id
            end

            if conversions = record['conversions']
              conversions.should_not include mingo_id
            end
          end
        end
      end
    end
  end
end
