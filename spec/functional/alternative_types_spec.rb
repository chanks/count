require 'spec_helper'

# Spec that ab_choose (which ab_test delegates to) returns proper values in roughly correct proportions.

describe "(THIS WILL FAIL OCCASIONALLY) ab_test, when given" do
  def test(alternatives)
    tester = mingo_tester do
      define_method :test do
        ab_test :test, alternatives
      end
    end

    results = Hash.new(0)
    100.times { results[tester.new.test] += 1 }
    results
  end

  it "a three-member array should return each value ~33% of the time" do
    results = test(%w(A B C))

    results.keys.sort.should == %w(A B C)
    results.values.each { |value| value.should be_within(15).of(33) }
  end

  it "a three-member range should return each value ~33% of the time" do
    results = test('a'..'c')

    results.keys.sort.should == %w(a b c)
    results.values.each { |value| value.should be_within(15).of(33) }
  end

  it "an integer should return another integer between it and 1" do
    results = test(3)

    results.keys.sort.should == [1, 2, 3]
    results.values.each { |value| value.should be_within(15).of(33) }
  end

  it "a hash should use its values as weights to return a key" do
    results = test('ferret' => 2, 'gopher' => 1)

    results.keys.sort.should == %w(ferret gopher)
    results['ferret'].should be_within(15).of(66)
    results['gopher'].should be_within(15).of(33)
  end
end
