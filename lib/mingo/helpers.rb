require 'digest/md5'

module Mingo
  module Helpers
    def ab_test(test_name, alternatives = nil, &block)
      result = ab_choose(test_name, alternatives, &block)

      if Mingo.collection
        user      = mingo_id
        selector  = { :_id => [test_name, result].join('/'), :test => test_name,
                      :alternative => result, :participants => { :$ne => user } }
        modifiers = { :$inc => { :participant_count => 1 }, :$push => { :participants => user } }

        Mingo.collection.update selector, modifiers, :upsert => true
      end

      result
    end

    def ab_choose(test_name, alternatives = nil)
      alternatives =
        case alternatives
          when nil     then [true, false]
          when Array   then alternatives
          when Integer then (1..alternatives).to_a
          when Hash    then alternatives.inject([]) { |array, (key, integer)| array += [key] * integer }
          else              alternatives.to_a
        end

      result =
        case Mingo.mode
          when :shuffle then alternatives.sample
          when :first   then alternatives.first
          when :standard
            digest = Digest::MD5.hexdigest(mingo_id.to_s + test_name.to_s)
            index  = digest.hex % alternatives.length
            alternatives[index]
        end

      yield result if block_given?
      result
    end

    def bingo!(*test_names)
      if Mingo.collection
        user      = mingo_id
        selector  = { :test => { :$in => test_names },
                      :participants => user, :conversions => { :$ne => user } }
        modifiers = { :$inc => { :conversion_count => 1 }, :$push => { :conversions => user } }

        Mingo.collection.update selector, modifiers, :multi => true
      end
    end

    private

    def mingo_id
      session[:mingo_id] ||= -rand(2**31)
    end
  end
end
