shared_examples_for "a bingo helper" do
  context "when the user has not participated" do
    it "and there are no previous participations or conversions should leave the database empty" do
      @tester.bingo
      Count.collection.count.should == 0
    end

    it "and there are previous participations/conversions should leave them unchanged" do
      populate :test => 'test', :alternatives => {true => [100, 10], false => [100, 10]}
      records = Count.collection.find.to_a

      @tester.bingo
      should_be_unchanged(records)
    end
  end

  context "when the user has participated" do
    it "and there are no other participations should create a single record for that user" do
      result = @tester.test
      @tester.bingo

      Count.collection.count.should == 1
      record = Count.collection.find_one
      record.should == { '_id'               => "test/#{result}",
                         'test'              => 'test',
                         'alternative'       => result,
                         'participants'      => [@tester.id],
                         'participant_count' => 1,
                         'conversions'       => [@tester.id],
                         'conversion_count'  => 1 }
    end

    context "and there are previous participations/conversions" do
      before do
        populate :test => 'test', :alternatives => {true => [100, 10], false => [100, 10]}
        @result = @tester.test

        @records = Count.collection.find.to_a
        @tester.bingo
      end

      it "the record count should remain the same" do
        Count.collection.count.should == @records.count
      end

      it "the record for the result should have it's conversions bumped by one" do
        record = @records.find { |record| record['alternative'] == @result }
        record['conversion_count'] += 1
        record['conversions'] << @tester.id

        should_be_unchanged(record)
      end

      it "the other records should be unchanged" do
        should_be_unchanged(@records.reject { |record| record['alternative'] == @result })
      end
    end
  end
end
