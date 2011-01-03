module Mingo
  module RailsMingoId
    private

    def mingo_id
      session[:mingo_id] ||= -rand(2**31)
    end
  end
end
