require 'spec_helper'

# When no collection is present/assigned, the ab_test
# helper should still behave like an ab_choose helper.

describe "When there is no collection defined" do
  before do
    @collection, Count.collection = Count.collection, nil

    @tester = count_tester do
      def choose
        ab_test :test
      end
    end.new
  end

  after { Count.collection = @collection }

  it_should_behave_like "an ab_choose helper"
end
