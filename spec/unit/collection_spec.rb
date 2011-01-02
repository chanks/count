require 'spec_helper'

describe "Mingo.collection" do
  it "should return the collection set in the rails app initializer" do
    c = Mingo.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'experiments'
    c.db.name.should == 'mingo_test'
  end

  it "when there is none set should raise an error" do
    actual_collection, Mingo.collection = Mingo.collection, nil

    proc { Mingo.collection }.should raise_error /Mingo doesn't have a collection to write to/

    Mingo.collection = actual_collection
  end
end

describe "Mingo.collection=" do
  it "when there is none existent should create a unique index on the experiment and alternative fields" do
    Mingo.collection.drop
    Mingo.collection = Mongo::Connection.new['mingo_test']['experiments']

    info = Mingo.collection.index_information['experiment_1_alternative_1']
    info['key'].should == {'experiment' => 1, 'alternative' => 1}
    info['unique'].should == true
  end
end
