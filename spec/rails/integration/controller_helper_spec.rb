require 'rails/spec_helper'

# Spec that Mingo's helpers are included in the controller automatically.

describe "An A/B boolean test in the controller" do
  # Trigger the a/b test, and return the true/false it chose.
  define_method :participate! do
    get "/controller_tests/test"
    eval(last_response.body.strip)
  end

  # Trigger the conversion.
  define_method :convert! do
    get "/controller_tests/bingo"
  end

  def load_record(boolean)
    Mingo.collection.find_one :test => 'boolean', :alternative => boolean
  end

  it "should return a value of true or false" do
    [true, false].should include participate!
  end

  it "should return each value approximately 50% of the time (this will fail occasionally)" do
    results = Hash.new(0)
    100.times { clear_cookies; results[participate!] += 1 }
    results.values.each { |value| value.should be_within(15).of(50) }
  end

  it "should always return the same value for a given user" do
    (1..10).map{ participate! }.uniq.count.should == 1
  end

  context "that returns a value for a user" do
    before { @boolean = participate! }

    it "should mark that user as a participant in the db" do
      record = load_record(@boolean)

      record['participant_count'].should == 1
      record['participants'].should == [assigned_mingo_id]
    end

    context "who then converts" do
      before { convert! }

      it "should be recorded as a conversion" do
        record = load_record(@boolean)

        record['participant_count'].should == 1
        record['participants'].should      == [assigned_mingo_id]
        record['conversion_count'].should  == 1
        record['conversions'].should       == [assigned_mingo_id]
      end
    end
  end
end
