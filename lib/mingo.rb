require 'mongo'

require 'mingo/alternative'
require 'mingo/engine'
require 'mingo/experiment'
require 'mingo/helpers'
require 'mingo/version'

module Mingo
  class << self
    def collection
      @collection || raise("Mingo doesn't have a collection to write to! Please give it one using Mingo.collection=, probably in an initializer.")
    end

    def collection=(collection)
      @collection = collection

      if @collection
        index = [['experiment', Mongo::ASCENDING], ['alternative', Mongo::ASCENDING]]
        @collection.create_index index, :unique => true
      end

      @collection
    end
  end
end
