require 'rails/spec_helper'

describe "Mingo.collection" do
  it "should return the collection set in the rails app production config file" do
    c = Mingo.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'results'
    c.db.name.should == 'mingo_rails_test'
  end
end
