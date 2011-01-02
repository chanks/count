require 'digest/md5'

module Mingo
  module Helpers
    def ab_test(test_name, alternatives = nil, options = {}, &block)
      if alternatives.is_a?(Hash) && alternatives.has_key?(:conversion)
        alternatives, options = nil, alternatives
      end

      result     = ab_choose(test_name, alternatives, &block)
      conversion = options[:conversion] || test_name

      selector  = { :experiment => test_name, :conversion => conversion,
                    :alternative => result, :participants => { :$ne => mingo_id } }
      modifiers = { :$inc => { :participant_count => 1 }, :$push => { :participants => mingo_id } }

      Mingo.collection.update(selector, modifiers, :upsert => true)

      result
    end

    def ab_choose(test_name, alternatives = nil)
      alternatives =
      case alternatives
        when nil     then [true, false]
        when Array   then alternatives
        when Integer then (1..alternatives).to_a
        when Hash    then alternatives.each_with_object([]) { |(key, int), array| int.times { array << key } }
        else              alternatives.to_a
      end

      digest = Digest::MD5.hexdigest(mingo_id.to_s + test_name.to_s)
      index  = digest.hex % alternatives.length
      result = alternatives[index]

      yield result if block_given?

      result
    end

    def bingo!(conversion)
      selector  = { :conversion => conversion, :participants => mingo_id, :conversions => { :$ne => mingo_id } }
      modifiers = { :$inc => { :conversion_count => 1 }, :$push => { :conversions => mingo_id } }
      Mingo.collection.update(selector, modifiers, :multi => true)
    end

    private

    def mingo_id
      session[:mingo_id] ||= rand 2**31
    end
  end
end
