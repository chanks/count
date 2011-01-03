require 'spec_helper'

describe "Two A/B tests that are converted simultaneously" do
  def array!
    get "/controller_tests/array"
    eval(last_response.body)
  end

  def boolean!
    get "/controller_tests/boolean"
    eval(last_response.body)
  end

  def range!
    get "/controller_tests/range"
    eval(last_response.body)
  end

  def convert! # converts array and boolean
    get "/controller_tests/multiple_bingo"
  end

  before do
    populate :test => 'array', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
    populate :test => 'boolean', :alternatives => {true => [100, 10], false => [100, 10]}
    populate :test => 'range', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
  end

  context "when the user participated in only one" do
    before do
      @number = array!
      convert!
    end

    it "should convert only the one they participated in" do
      Mingo.collection.find.to_a.each do |record|
        if record['test'] == 'array' && record['alternative'] == @number
          record['conversions'].should include mingo_id
        else
          record['conversions'].should_not include mingo_id
        end
      end
    end
  end

  context "when the user participated in both" do
    before do
      @number, @boolean = array!, boolean!
      convert!
    end

    it "should convert both of them" do
      Mingo.collection.find.to_a.each do |record|
        if (record['test'] == 'array'   && record['alternative'] == @number ) ||
           (record['test'] == 'boolean' && record['alternative'] == @boolean)
          record['conversions'].should include mingo_id
        else
          record['conversions'].should_not include mingo_id
        end
      end
    end
  end

  context "when a third test was also participated in" do
    before do
      @number, @boolean, @other_number = array!, boolean!, range!
      convert!
    end

    it "should convert all but the range" do
      Mingo.collection.find.to_a.each do |record|
        if (record['test'] == 'array'   && record['alternative'] == @number ) ||
           (record['test'] == 'boolean' && record['alternative'] == @boolean)
          record['conversions'].should include mingo_id
        else
          record['conversions'].should_not include mingo_id
        end
      end
    end
  end
end
