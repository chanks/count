require 'spec_helper'

# The ab_test helper is supposed to do everything the ab_choose
# helper does, so we run the ab_choose specs against it too.

describe "The ab_test helper" do
  before do
    @tester = mingo_tester do
      def choose
        ab_test :test, [1, 2, 3]
      end
    end.new
  end

  it_should_behave_like "an ab_test helper"
  it_should_behave_like "an ab_choose helper"
end
