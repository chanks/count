require 'spec_helper'

branch :array, :boolean, :range do |test_type|
  describe "An A/B #{test_type} test" do

    # Trigger the a/b test, and return the value it chose.
    define_method :participate! do
      get "/controller_tests/#{test_type}"
      eval(last_response.body)
    end

    # Trigger the conversion.
    define_method :convert! do
      get "/controller_tests/#{test_type}_bingo"
    end

    define_method :results_for do |alternative|
      Mingo.collection.find_one :experiment => "#{test_type}_test", :alternative => alternative
    end

    if test_type.boolean?
      it "should return a value of true or false" do
        [true, false].should include participate!
      end

      it "should return each value approximately 50% of the time" do
        results = Hash.new(0)
        100.times { clear_cookies; results[participate!] += 1 }
        results.values.each { |value| value.should be_within(10).of(50) }
      end
    end

    if test_type.array? || test_type.range?
      it "should return a value of 1, 2 or 3" do
        [1, 2, 3].should include participate!
      end

      it "should return each value approximately 33% of the time" do
        results = Hash.new(0)
        100.times { clear_cookies; results[participate!] += 1 }
        results.values.each { |value| value.should be_within(10).of(33) }
      end
    end

    it "should always return the same value for a given user" do
      (1..10).map{ participate! }.uniq.count.should == 1
    end

    context "that returns a value for a user" do
      before { @alternative = participate! }

      it "should mark that user as a participant in the db" do
        record = results_for(@alternative)

        record['participant_count'].should == 1
        record['participants'].should      == [mingo_id]
      end

      it "several times should mark that user as a participant only once" do
        3.times { participate! }
        record = results_for(@alternative)

        record['participant_count'].should == 1
        record['participants'].should      == [mingo_id]
      end

      context "who then converts" do
        before { convert! }

        it "should be recorded as a conversion" do
          record = results_for(@alternative)

          record['participant_count'].should == 1
          record['participants'].should      == [mingo_id]
          record['conversion_count'].should  == 1
          record['conversions'].should       == [mingo_id]
        end

        it "several times should be recorded as a conversion only once" do
          3.times { convert! }
          record = results_for(@alternative)

          record['participant_count'].should == 1
          record['participants'].should == [mingo_id]
          record['conversion_count'].should == 1
          record['conversions'].should == [mingo_id]
        end
      end
    end

    it "that has a conversion for a user that hasn't participated should not record it" do
      convert!
      Mingo.collection.count.should == 0
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

      context "and returns a value for a user" do
        before { @alternative = participate! }

        it "should mark that user as a participant in the db" do
          results_for(@alternative)['participants'].should include mingo_id
        end

        it "several times should mark that user as a participant only once" do
          3.times { participate! }

          results_for(@alternative)['participants'].select{ |p| p == mingo_id }.count.should == 1
        end

        context "who then converts" do
          before { convert! }

          it "should be recorded as a conversion" do
            record = results_for(@alternative)

            record['participants'].should include mingo_id
            record['conversions'].should include mingo_id
          end

          it "several times should be recorded as a conversion only once" do
            3.times { convert! }

            results_for(@alternative)['conversions'].select{ |p| p == mingo_id }.count.should == 1
          end
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
    end
  end
end
