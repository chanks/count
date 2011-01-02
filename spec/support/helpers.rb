# Helper to run a set of specs several times under different conditions.
def branch(*args, &block)
  args.map { |sym| ActiveSupport::StringInquirer.new sym.to_s }.each(&block)
end

def mingo_id
  last_response.headers['mingo_id'].to_i
end

def populate(hash)
  hash[:alternatives].each do |alternative, (participant_count, conversion_count)|
    doc = {
      :experiment        => hash[:experiment],
      :alternative       => alternative,
      :participant_count => participant_count,
      :participants      => [],
      :conversion_count  => conversion_count,
      :conversions       => []
    }

    Mingo.collection.insert(doc)
  end
end
