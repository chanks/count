require 'spec_helper'

describe "A bingo! helper passed several tests" do
  before do
    %w(test_1 test_2 test_3 test_4).each do |test_name|
      populate :test => test_name, :alternatives => { true => [100, 10], false => [100, 10] }
    end

    @tester = mingo_tester do
      def test
        [:test_1, :test_2, :test_3].map { |test_name| ab_test(test_name) }
      end

      def bingo
        bingo! :test_1, :test_2, :test_4
      end
    end.new

    @first, @second, @third = @tester.test

    @records = Mingo.collection.find.to_a

    @tester.bingo
  end

  it "the user should appear in the conversions for all the tests he participated in and bingoed" do
    {'test_1' => @first, 'test_2' => @second}.each do |test_name, result|
      record = @records.find { |record| record['test'] == test_name && record['alternative'] == result }

      record['conversions'] << @tester.id
      record['conversion_count'] += 1
      should_be_unchanged(record)
    end
  end

  it "all records that weren't participated in and bingoed should be unchanged" do
    records = @records.reject { |record| [['test_1', @first], ['test_2', @second]].include? [record['test'], record['alternative']] }
    records.count.should == 6

    should_be_unchanged(records)
  end
end
