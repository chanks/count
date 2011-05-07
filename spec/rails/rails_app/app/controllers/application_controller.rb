class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :include_count_id_in_headers

  private

  # Helps out with some of the specs. Don't do this in production.
  def include_count_id_in_headers
    headers['count_id'] = count_id.to_s
  end
end
