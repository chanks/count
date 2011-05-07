require 'spec_helper'

describe "Count.index!" do
  it "should create a unique index on the 'test' and 'alternative' fields" do
    c = Count.collection
    c.index_information.keys.should == %w(_id_)

    Count.index!

    info = c.index_information['test_1_alternative_1']
    info['key'].should == {'test' => 1, 'alternative' => 1}
    info['unique'].should == true

    Count.collection.drop_indexes
  end
end
