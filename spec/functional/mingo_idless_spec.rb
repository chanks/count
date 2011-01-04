require 'spec_helper'

describe "When a model doesn't define a #mingo_id method" do
  before do
    @tester = Class.new do
      include Mingo::Helpers

      def test
        ab_test :test
      end

      def bingo
        bingo! :test
      end
    end.new
  end

  it "usage of the ab_test helper will throw an error" do
    proc { @tester.test }.should raise_error StandardError, /You need to define #mingo_id/
  end

  it "usage of the bingo! helper will throw an error" do
    proc { @tester.bingo }.should raise_error StandardError, /You need to define #mingo_id/
  end
end
