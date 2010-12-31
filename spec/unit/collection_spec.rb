require 'spec_helper'

describe "Mingo.collection" do
  it "should return the collection set in the rails app initializer" do
    c = Mingo.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'experiments'
    c.db.name.should == 'mingo_test'
  end

  it "should raise an error if it is nil" do
    actual_collection, Mingo.collection = Mingo.collection, nil

    proc { Mingo.collection }.should raise_error /Mingo doesn't have a collection to write to/

    Mingo.collection = actual_collection
  end
end
