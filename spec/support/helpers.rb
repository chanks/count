def populate(hash)
  hash[:alternatives].each do |alternative, (participant_count, conversion_count)|
    doc = { :_id               => hash[:test] + '/' + alternative.to_s,
            :test              => hash[:test],
            :alternative       => alternative,
            :participant_count => participant_count,
            :participants      => (1..20).map{-rand(2**31)},
            :conversion_count  => conversion_count,
            :conversions       => (1..20).map{-rand(2**31)} }

    Count.collection.insert(doc)
  end
end
