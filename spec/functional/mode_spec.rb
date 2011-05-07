require 'spec_helper'

describe "When Count.mode =" do
  before { @tester = count_tester.new }
  after  { Count.mode = :standard     }

  def results
    hash = Hash.new(0)
    100.times { hash[@tester.choose] += 1 }
    hash
  end

  it ":standard ab_choose behaves typically" do
    Count.mode = :standard
    results.values.first.should == 100
  end

  it ":shuffle ab_choose gives a new random value every time" do
    Count.mode = :shuffle
    results.values.each { |value| value.should be_within(15).of(50) }
  end

  it ":first ab_choose gives the first value every time" do
    Count.mode = :first
    results.should == {true => 100}
  end
end
