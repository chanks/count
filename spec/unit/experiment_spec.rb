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
