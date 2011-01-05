require 'spec_helper'

# Spec that in presence of a block, the result is still returned by
# the helpers, and they still behave the same as without the block.

describe "When given a block" do
  before do
    @tester = mingo_tester do
      def test
        ab_test(:test) { |result| result.to_s * 10 }
      end

      def choose
        ab_choose(:test) { |result| result.to_s * 10 }
      end
    end.new
  end

  it_should_behave_like "an ab_test helper"
  it_should_behave_like "an ab_choose helper"

  it "#ab_test should still return the value it selected" do
    [true, false].should include @tester.test
  end

  it "#ab_choose should still return the value it selected" do
    [true, false].should include @tester.choose
  end
end
