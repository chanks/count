module Count
  module RailsCountId
    private

    def count_id
      session[:count_id] ||= -rand(2**31)
    end
  end
end
