module Mingo
  class Config
    include Singleton

    attr_reader :collection

    def collection=(collection)
      if collection.nil? || collection.is_a?(Mongo::Collection)
        @collection = collection
      else
        raise StandardError, "Mingo expected to be passed an instance of Mongo::Collection, but was instead given #{collection}"
      end
    end

    attr_writer :mode

    def mode
      @mode ||= if defined? Rails
                  case Rails.env
                    when 'development' then :shuffle
                    when 'test'        then :first
                    when 'production'  then :standard
                  end
                else
                  :standard
                end
    end

    def index!
      index = [['test', Mongo::ASCENDING], ['alternative', Mongo::ASCENDING]]
      @collection.create_index index, :unique => true
    end
  end
end
