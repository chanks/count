require 'rails/spec_helper'

describe "Count.collection" do
  it "should return the collection set in the rails app production config file" do
    c = Count.collection

    c.should be_an_instance_of Mongo::Collection
    c.name.should    == 'results'
    c.db.name.should == 'count_rails_test'
  end
end
