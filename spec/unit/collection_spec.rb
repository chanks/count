require 'spec_helper'

describe "Mingo.collection" do
  it "should return the collection set in the rails app initializer" do
    c = Mingo.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'experiments'
    c.db.name.should == 'mingo_test'
  end
end

describe "Mingo.collection=" do
  it "when there is none existent should create a unique index on the test and alternative fields" do
    Mingo.collection.drop
    Mingo.collection = Mongo::Connection.new['mingo_test']['experiments']

    info = Mingo.collection.index_information['test_1_alternative_1']
    info['key'].should == {'test' => 1, 'alternative' => 1}
    info['unique'].should == true
  end
end
