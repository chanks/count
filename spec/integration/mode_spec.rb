require 'spec_helper'

describe "Mingo.mode =" do
  def participate!
    get "/controller_tests/array"
    eval(last_response.body)
  end

  after { Mingo.mode = :standard }

  context ":shuffle" do
    before { Mingo.mode = :shuffle }

    it "a test should return a new random result every time, even for the same user" do
      results = Hash.new(0)
      100.times { results[participate!] += 1 }
      results.values.each { |value| value.should be_within(15).of(33) }
    end
  end

  context ":first" do
    before { Mingo.mode = :first }

    it "a test should always return the first of its alternatives" do
      results = Hash.new(0)
      100.times { results[participate!] += 1 }
      results.should == {1 => 100}
    end
  end
end
