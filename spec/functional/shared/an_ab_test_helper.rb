shared_examples_for "an ab_test helper" do
  context "and there have been no previous participations" do
    [1, 5].each do |count|
      context "and the user participates #{count} times" do
        before { count.times { @result = @tester.test } }

        it "a single record for that user + test + result should be in the db" do
          Mingo.collection.count.should    == 1
          Mingo.collection.find_one.should == { '_id'               => "test/#{@result}",
                                                'test'              => 'test',
                                                'alternative'       => @result,
                                                'participants'      => [@tester.id],
                                                'participant_count' => 1 }
        end
      end
    end
  end

  context "and there have been some previous participations" do
    before do
      populate :test => 'test', :alternatives => {1 => [100, 10], 2 => [100, 10], 3 => [100, 10]}
      @records = Mingo.collection.find.to_a
    end

    [1, 5].each do |count|
      context "and the user participates #{count} times" do
        before { count.times { @result = @tester.test } }

        it "the collection count should be unchanged" do
          Mingo.collection.count.should == @records.count
        end

        it "the records for the other results should be unchanged" do
          should_be_unchanged(@records.reject { |record| record['alternative'] == @result })
        end

        it "the record for the received result should be updated to reflect it" do
          record = @records.find { |record| record['alternative'] == @result }
          record['participant_count'] += 1
          record['participants'] << @tester.id

          should_be_unchanged(record)
        end
      end
    end
  end
end
