shared_examples_for "an ab_choose helper" do
  it "the same user should see the same result every time" do
    (1..10).map{ @tester.choose }.uniq.count.should == 1
  end

  it "different users should see different results (THIS WILL FAIL OCCASIONALLY)" do
    results = Hash.new(0)
    100.times { @tester.randomize_id!; results[@tester.choose] += 1 }

    results.keys.sort.should == [1, 2, 3]
    results.values.each { |value| value.should be_within(15).of(33) }
  end
end
