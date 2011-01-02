require 'singleton'

module Mingo
  class Config
    include Singleton

    attr_reader :collection

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
