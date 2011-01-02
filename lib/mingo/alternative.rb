module Mingo
  class Alternative
    attr_reader :id, :participant_count, :conversion_count

    def initialize(doc)
      @id                = doc['alternative']
      @participant_count = doc['participant_count']
      @conversion_count  = doc['conversion_count'] || 0
    end

    def conversion_rate
      @conversion_count.to_f / @participant_count
    end

    def conversion_percentage
      "%4.2f%" % (conversion_rate * 100)
    end

    def results
      "#{@id} converted #{conversion_percentage} of users (#{@conversion_count} of #{@participant_count})."
    end
  end
end
