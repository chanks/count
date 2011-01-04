def should_be_unchanged(*records)
  records.flatten.each do |record|
    comparison = Mingo.collection.find_one(:_id => record['_id'])

    comparison.keys.sort.should == record.keys.sort
    comparison.keys.each do |key|
      comparison[key].should == record[key]
    end
  end
end
