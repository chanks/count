# Helper to run a set of specs several times under different conditions.
def branch(*args, &block)
  args.map { |sym| ActiveSupport::StringInquirer.new sym.to_s }.each(&block)
end

def assigned_mingo_id
  last_response.headers['mingo_id'].to_i
end

def populate(hash)
  hash[:alternatives].each do |alternative, (participant_count, conversion_count)|
    doc = { :_id               => hash[:test] + '/' + alternative.to_s,
            :test              => hash[:test],
            :alternative       => alternative,
            :participant_count => participant_count,
            :participants      => (1..20).map{-rand(2**31)},
            :conversion_count  => conversion_count,
            :conversions       => (1..20).map{-rand(2**31)} }

    Mingo.collection.insert(doc)
  end
end
