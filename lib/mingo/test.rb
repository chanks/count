module Mingo
  class Test
    class << self
      def parse_all
        fields = %w(test alternative participant_count conversion_count)

        alts = Mingo.collection.find({}, {:fields => fields}).group_by { |doc| doc['test'] }

        alts.map { |test, alternatives| new(test, alternatives) }
      end
    end

    attr_reader :id, :alternatives

    def initialize(test, alternatives)
      @id           = test
      @alternatives = alternatives.map { |doc| Alternative.new(doc) }
    end

    def results
      chunks = @alternatives.count - 1
      output = ""

      alts = @alternatives.sort_by(&:conversion_rate).reverse

      alts.each do |alternative|
        output << alternative.results
        output << "\n"
      end

      output << "\n"

      chunks.times do |i|
        first, second = alts[i], alts[i + 1]

        z = z_score_between_alternatives(first, second)
        p = p_score_from_z_score(z)

        percent = "%5f%" % (p * 100)

        output << "There is a #{percent} probability that #{first.id} scored better than #{second.id} due to chance alone."
        output << "\n"
      end

      output
    end

    # Shamelessly copy-pasted from A/Bingo, by Patrick McKenzie.
    def z_score_between_alternatives(first, second)
      cr1 = first.conversion_rate
      cr2 = second.conversion_rate

      n1 = first.participant_count
      n2 = second.participant_count

      numerator = cr1 - cr2
      frac1 = cr1 * (1 - cr1) / n1
      frac2 = cr2 * (1 - cr2) / n2

      numerator / ((frac1 + frac2) ** 0.5)
    end


    # Shamelessly copy-pasted from Aidan Findlater's blog.
    # http://www.aidanfindlater.com/calculating-the-area-under-the-normal-curve-in-ruby
    def p_score_from_z_score(x, upper = true)
      # Local variables
      con = 1.28 ; fn_val = 0.0

      # Machine dependent constants
      # I arbitrarily left them untouched -- refer to the paper for more information
      ltone = 7.0 ; utzero = 18.66

      p = 0.398942280444 ; q = 0.39990348504 ; r = 0.398942280385
      a1 = 5.75885480458 ; a2 = 2.62433121679 ; a3 = 5.92885724438
      b1 = -29.8213557807 ; b2 = 48.6959930692
      c1 = -3.8052E-8 ; c2 = 3.98064794E-4 ; c3 = -0.151679116635 ; c4 = 4.8385912808 ; c5 = 0.742380924027 ; c6 = 3.99019417011
      d1 = 1.00000615302 ; d2 = 1.98615381364 ; d3 = 5.29330324926 ; d4 = -15.1508972451 ; d5 = 30.789933034

      up = upper
      z = x

      if z < 0.0
         up = !up
         z = -z
      end

      if (z <= ltone or (up and z <= utzero))
         y = 0.5*z*z
         if (z > con)
            fn_val = r*Math.exp(-y)/(z+c1+d1/(z+c2+d2/(z+c3+d3/(z+c4+d4/(z+c5+d5/(z+c6))))))
         else
            fn_val = 0.5 - z*(p-q*y/(y+a1+b1/(y+a2+b2/(y+a3))))
         end
      else
         fn_val = 0.0
      end

      if (!up) ; fn_val = 1.0 - fn_val ; end

      fn_val
    end
  end
end
