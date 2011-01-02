require 'singleton'

module Mingo
  class Config
    include Singleton

    attr_accessor :collection
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
