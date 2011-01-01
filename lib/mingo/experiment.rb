module Mingo
  class Experiment
    class << self
      def parse_all
        fields = %w(experiment conversion alternative participant_count conversion_count)

        alts = Mingo.collection.find({}, {:fields => fields}).group_by { |doc| doc['experiment'] }

        alts.map { |experiment, alternatives| new(experiment, alternatives) }
      end
    end

    attr_reader :id, :alternatives

    def initialize(experiment, alternatives)
      @id           = experiment
      @alternatives = alternatives.map { |doc| Alternative.new(doc) }
    end
  end
end
