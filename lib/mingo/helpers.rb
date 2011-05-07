module Mingo
  module Helpers
    def ab_choose(test_name, alternatives = nil)
      user = mingo_id

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
          when :shuffle then alternatives[rand(alternatives.count)]
          when :first   then alternatives.first
          when :standard
            digest = Digest::MD5.hexdigest(user.to_s + test_name.to_s)
            index  = digest.hex % alternatives.length
            alternatives[index]
        end

      yield result if block_given?
      result
    end

    def ab_test(test_name, alternatives = nil)
      result = ab_choose(test_name, alternatives)
      user   = mingo_id

      if Mingo.collection
        selector  = { :_id => [test_name, result].join('/'), :test => test_name.to_s,
                      :alternative => result, :participants => { :$ne => user } }
        modifiers = { :$inc => { :participant_count => 1 }, :$push => { :participants => user } }

        Mingo.collection.update selector, modifiers, :upsert => true
      end

      yield result if block_given?
      result
    end

    def bingo!(*test_names)
      user = mingo_id

      if Mingo.collection
        selector  = { :test => { :$in => test_names.map { |name| name.to_s } },
                      :participants => user, :conversions => { :$ne => user } }
        modifiers = { :$inc => { :conversion_count => 1 }, :$push => { :conversions => user } }

        Mingo.collection.update selector, modifiers, :multi => true
      end
    end

    private

    def mingo_id
      if defined? super
        super
      else
        raise StandardError, "You need to define #mingo_id so that Mingo knows how to identify your user!"
      end
    end
  end
end
