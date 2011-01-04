require 'spec_helper'

describe "When Mingo.mode =" do
  before { @tester = mingo_tester.new }
  after  { Mingo.mode = :standard     }

  def results
    hash = Hash.new(0)
    100.times { hash[@tester.choose] += 1 }
    hash
  end

  it ":standard ab_choose behaves typically" do
    Mingo.mode = :standard
    results.values.first.should == 100
  end

  it ":shuffle ab_choose gives a new random value every time" do
    Mingo.mode = :shuffle
    results.values.each { |value| value.should be_within(15).of(33) }
  end

  it ":first ab_choose gives the first value every time" do
    Mingo.mode = :first
    results.should == {1 => 100}
  end
end
