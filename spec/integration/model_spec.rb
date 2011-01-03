require 'spec_helper'

describe "When the Mingo helpers are mixed in to a class and ab_test is triggered" do
  before do
    @user = User.new("Sammy")
    @user.test
  end

  it "the participant should be identified by the return value of the class's mingo_id" do
    record = Mingo.collection.find_one
    record['participants'].should == ["Sammy-san"]
  end

  context "and then converts" do
    before { @user.bingo }

    it "the conversion should be identified by the return value of the class's mingo_id" do
      record = Mingo.collection.find_one
      record['conversions'].should == ["Sammy-san"]
    end
  end
end
