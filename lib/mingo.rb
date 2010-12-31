require 'mongo'

require 'mingo/engine'
require 'mingo/helpers'
require 'mingo/version'

module Mingo
  class << self
    def collection
      @collection || raise("Mingo doesn't have a collection to write to! Please give it one using Mingo.collection=, probably in an initializer.")
    end

    def collection=(collection)
      @collection = collection
      @collection.create_index([['experiment', Mongo::ASCENDING], ['alternative', Mongo::ASCENDING]], :unique => true)
      @collection
    end
  end
end
