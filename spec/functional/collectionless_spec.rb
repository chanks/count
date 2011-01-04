require 'spec_helper'

# When no collection is present/assigned, the ab_test
# helper should still behave like an ab_choose helper.

describe "When there is no collection defined" do
  before do
    @collection, Mingo.collection = Mingo.collection, nil

    @tester = mingo_tester do
      def choose
        ab_test :test, [1, 2, 3]
      end
    end.new
  end

  after { Mingo.collection = @collection }

  it_should_behave_like "an ab_choose helper"
end
