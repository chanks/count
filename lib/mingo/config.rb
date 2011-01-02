require 'singleton'

module Mingo
  class Config
    include Singleton

    attr_reader :collection

    def collection=(collection)
      @collection = collection

      if @collection
        index = [['test', Mongo::ASCENDING], ['alternative', Mongo::ASCENDING]]
        @collection.create_index index, :unique => true
      end

      @collection
    end

    attr_writer :mode

    def mode
      @mode ||= case Rails.env
                  when 'development' then :shuffle
                  when 'test'        then :first
                  when 'production'  then :standard
                end
    end
  end
end
