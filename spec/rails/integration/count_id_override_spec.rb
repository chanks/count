require 'rails/spec_helper'

# Spec that the count_id method is overridable in the controller.

describe "When the count_id method is overridden and a user participates" do
  before { get '/count_id_overrides/test/hash_me' }

  it "the value it returns should be used in the ab_test helper" do
    record = Count.collection.find_one
    record['participants'].should == ['ca505b9a1a45ed002689228bdf25225d']
  end

  context "and then converts" do
    before { get '/count_id_overrides/bingo/hash_me' }

    it "the value it returns should be used in the bingo! helper" do
      record = Count.collection.find_one
      record['conversions'].should == ['ca505b9a1a45ed002689228bdf25225d']
    end
  end
end
