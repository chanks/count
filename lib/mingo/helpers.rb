require 'digest/md5'

module Mingo
  module Helpers
    def ab_test(test_name, alternatives = [true, false])
      alternatives = alternatives.to_a

      hash   = Digest::MD5.hexdigest(mingo_id.to_s + test_name.to_s)
      index  = hash.hex % alternatives.length
      result = alternatives[index]

      selector  = {:experiment => test_name, :alternative => result, :participants => {:$ne => mingo_id}}
      modifiers = {'$inc' => {'participant_count' => 1}, '$push' => {'participants' => mingo_id}}
      Mingo.collection.update(selector, modifiers, :upsert => true)

      result
    end

    def bingo!(test_name)
      selector  = {:experiment => test_name, :participants => mingo_id, :conversions => {:$ne => mingo_id}}
      modifiers = {'$inc' => {'conversion_count' => 1}, '$push' => {'conversions' => mingo_id}}
      Mingo.collection.update(selector, modifiers)
    end

    private

    def mingo_id
      session[:mingo_id] ||= rand 2**31
    end
  end
end
