require 'spec_helper'

describe "Mingo.collection" do
  it "should return the collection set in the rails app initializer" do
    c = Mingo.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'mingo_results'
    c.db.name.should == 'mingo_test'
  end
end
