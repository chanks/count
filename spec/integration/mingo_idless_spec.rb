require 'spec_helper'

describe "When a model includes Mingo::Helpers but doesn't define a #mingo_id method" do
  before do
    @user = MingoIdlessUser.new("Jon")
  end

  it "usage of the ab_test helper will throw an error" do
    proc { @user.test }.should raise_error StandardError, /You need to define #mingo_id/
  end

  it "usage of the bingo! helper will throw an error" do
    proc { @user.bingo }.should raise_error StandardError, /You need to define #mingo_id/
  end
end
