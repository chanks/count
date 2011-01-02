require 'spec_helper'

describe "Multiple A/B tests that will be simultaneously converted" do

  # Hits an ab_test helper with an explicit conversion name.
  define_method :participate! do
    get "/controller_tests/multiple_conversion"
    last_response.body.split('-').map { |element| eval(element) }
  end

  # Trigger the conversion.
  define_method :convert! do
    get "/controller_tests/multiple_conversion_bingo"
  end

  it "should always return the same value for a given user" do
    (1..10).map{ participate! }.uniq.count.should == 1
  end

  context "that return values for a user who converts" do
    before do
      @number, @boolean, @other_1, @other_2 = participate!
      convert!
    end

    it "should mark that user as a conversion for those tests" do
      first  = Mingo.collection.find_one(:test => 'test_1', :alternative => @number)
      second = Mingo.collection.find_one(:test => 'test_2', :alternative => @boolean)

      [first, second].each do |record|
        record['participants'].should include mingo_id
        record['conversions'].should include mingo_id
      end
    end

    it "should not mark that user as a conversion for the other tests" do
      first  = Mingo.collection.find_one(:test => 'other_1', :alternative => @other_1)
      second = Mingo.collection.find_one(:test => 'other_2', :alternative => @other_2)

      [first, second].each do |record|
        record['participants'].should include mingo_id
        record['conversions'].should be_nil
      end
    end
  end

  # Upserts bite me every once in a while, so I like to make sure
  # the behavior stays the same whether or not the record is already there.
  context "that have already recorded participations/conversions for some users" do
    before do
      20.times do |i|
        participate!
        convert! if i.even?
        clear_cookies
      end
    end

    context "that return values for a user who converts" do
      before do
        @number, @boolean, @other_1, @other_2 = participate!
        convert!
      end

      it "should mark that user as a conversion for those tests" do
        first  = Mingo.collection.find_one(:test => 'test_1', :alternative => @number)
        second = Mingo.collection.find_one(:test => 'test_2', :alternative => @boolean)

        [first, second].each do |record|
          record['participants'].should include mingo_id
          record['conversions'].should include mingo_id
        end
      end

      it "should not mark that user as a conversion for the other tests" do
        first  = Mingo.collection.find_one(:test => 'other_1', :alternative => @other_1)
        second = Mingo.collection.find_one(:test => 'other_2', :alternative => @other_2)

        [first, second].each do |record|
          if record
            record['participants'].should include mingo_id
            record['conversions'].should_not include mingo_id if record['conversions']
          end
        end
      end
    end
  end
end
