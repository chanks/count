require 'spec_helper'

describe "Experiment.parse_all" do
  before do
    populate :experiment => "boolean", :alternatives => {true => [1500, 300], false => [1500, 150]}
    populate :experiment => "array", :alternatives => {1 => [950, 300], 2 => [1000, 100], 3 => [1050, 50]}
    @experiments = Mingo::Experiment.parse_all
  end

  it "should return an array of individual experiments" do
    @experiments.count.should == 2
    @experiments.each { |exp| exp.should be_an_instance_of Mingo::Experiment }
    @experiments.map(&:id).sort.should == %w(array boolean)
  end

  it "should assign an array of alternatives to each experiment" do
    @experiments.each do |experiment|
      experiment.alternatives.each { |alt| alt.should be_an_instance_of Mingo::Alternative }
    end
  end

  it "should properly set the results of each alternative" do
    experiment  = @experiments.find { |exp| exp.id == 'array' }
    alternative = experiment.alternatives.find { |alt| alt.id == 2 }

    alternative.participant_count.should == 1000
    alternative.conversion_count.should  == 100
  end
end

describe "Experiment#results" do
  before do
    populate :experiment => "array", :alternatives => {1 => [980, 140], 2 => [1010, 100], 3 => [990, 85]}
    @results = Mingo::Experiment.parse_all.first.results
  end

  it "should output a human-readable summary of the results with some relevant data points" do
    [
      "1 converted 14.29% of users (140 of 980).",
      "2 converted 9.90% of users (100 of 1010).",
      "3 converted 8.59% of users (85 of 990).",
      "There is a 0.133908% probability that 1 scored better than 2 due to chance alone.",
      "There is a 15.485142% probability that 2 scored better than 3 due to chance alone."
    ].each do |string|
      @results.should include string
    end
  end
end