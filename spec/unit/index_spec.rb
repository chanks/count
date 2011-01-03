require 'spec_helper'

describe "Mingo.index!" do
  it "should create a unique index on the 'test' and 'alternative' fields" do
    c = Mingo.collection
    c.index_information.keys.should == %w(_id_)

    Mingo.index!

    info = c.index_information['test_1_alternative_1']
    info['key'].should == {'test' => 1, 'alternative' => 1}
    info['unique'].should == true

    Mingo.collection.drop_indexes
  end
end
