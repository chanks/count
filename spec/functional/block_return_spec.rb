require 'spec_helper'

# Spec that the helpers yield the result to a block.

describe "When returning the value yielded to a block" do
  before do
    @tester = mingo_tester do
      def test
        ab_test(:test) { |result| return result }
      end

      def choose
        ab_choose(:test) { |result| return result }
      end
    end.new
  end

  it_should_behave_like "an ab_test helper"
  it_should_behave_like "an ab_choose helper"
end
