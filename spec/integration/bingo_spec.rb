require 'spec_helper'

# spec the 'bingo!' helper for marking conversions.

describe "bingo!" do
  def choose!
    get "/controller_tests/array_choose"
    eval(last_response.body)
  end

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

  context "when the user has not triggered an ab_test helper" do
    before do
      populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      convert!
    end

    it "should not record them as a conversion" do
      Mingo.collection.find.to_a.each do |record|
        record['conversions'].should_not include assigned_mingo_id
      end
    end
  end

  context "when the user has only triggered an ab_choose helper" do
    before do
      populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      choose!
      convert!
    end

    it "should not record them as a conversion" do
      Mingo.collection.find.to_a.each do |record|
        record['conversions'].should_not include assigned_mingo_id
      end
    end
  end

  context "when the test has no previous conversions" do
    before do
      @number = participate!
      convert!
    end

    it "should record them as a conversion" do
      results_for(@number)['conversions'].should include assigned_mingo_id
    end
  end

  context "when the test has previous conversions" do
    before do
      populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      @number = participate!
      convert!
    end

    it "should record them as a conversion" do
      results_for(@number)['conversions'].should include assigned_mingo_id
    end
  end

  context "multiple times" do
    before do
      @number = participate!
      5.times { convert! }
    end

    it "should record them as a conversion only once" do
      record = results_for(@number)
      record['conversion_count'].should == 1
      record['conversions'].should include assigned_mingo_id
    end
  end
end
