require 'spec_helper'

describe "The alternatives of a test that has been run" do
  before do
    populate :test => "array", :alternatives => {1 => [1000, 100], 2 => [1000, 300], 3 => [1000, 50]}
    @test         = Mingo::Test.all.first
    @alternatives = @test.alternatives
  end

  it "should calculate the proper conversion rate and percentage" do
    {1 => [0.1, '10.00%'], 2 => [0.3, '30.00%'], 3 => [0.05, '5.00%']}.each do |id, (rate, percent)|
      alternative = @alternatives.find { |alt| alt.id == id }
      alternative.conversion_rate.should       == rate
      alternative.conversion_percentage.should == percent
    end
  end
end
