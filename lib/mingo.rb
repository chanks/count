require 'mongo'

require 'mingo/engine'
require 'mingo/version'

module Mingo
  class << self
    attr_writer :collection

    def collection
      @collection || raise("Mingo doesn't have a collection to write to! Please give it one using Mingo.collection=, probably in an initializer.")
    end
  end
end
