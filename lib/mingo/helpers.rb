require 'digest/md5'

module Mingo
  module Helpers
    def ab_test(test_name)
      alternatives = [true, false]

      hash  = Digest::MD5.hexdigest(mingo_id.to_s + test_name.to_s)
      index = hash.hex % alternatives.length

      alternatives[index]
    end

    private

    def mingo_id
      session[:mingo_id] ||= rand 2**31
    end
  end
end
