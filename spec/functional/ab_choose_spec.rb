require 'spec_helper'

describe "The ab_choose helper" do
  before { @tester = count_tester.new }

  it_should_behave_like "an ab_choose helper"
end
