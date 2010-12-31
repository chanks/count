module Mingo
  module Helpers
    def ab_test(test_name)
      [true, false].sample
    end
  end
end
