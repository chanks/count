require 'spec_helper'

describe "The bingo! helper" do
  context "in its default state" do
    before do
      @tester = count_tester.new
    end

    it_should_behave_like "a bingo helper"
  end

  context "with other tests to convert defined" do
    before do
      @tester = count_tester do
        def bingo
          bingo! :test, :test_again, :test_the_third
        end
      end.new
    end

    it_should_behave_like "a bingo helper"
  end

  context "with the test defined as a strings" do
    before do
      @tester = count_tester do
        def bingo
          bingo! 'test'
        end
      end.new
    end

    it_should_behave_like "a bingo helper"
  end
end
