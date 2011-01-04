require 'spec_helper'

describe "ab_test/ab_choose, when given string arguments instead of symbols" do
  before do
    @tester = mingo_tester do
      def test
        ab_test 'test', [1, 2, 3]
      end

      def choose
        ab_choose 'test', [1, 2, 3]
      end
    end.new
  end

  it_should_behave_like "an ab_test helper"
  it_should_behave_like "an ab_choose helper"
end
