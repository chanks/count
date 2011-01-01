module Mingo
  class Alternative
    attr_reader :id, :participant_count, :conversion_count

    def initialize(doc)
      @id                = doc['alternative']
      @participant_count = doc['participant_count']
      @conversion_count  = doc['conversion_count'] || 0
    end
  end
end
