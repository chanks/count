class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :include_mingo_id_in_headers

  private

  # Helps out with some of the specs. Don't do this in production.
  def include_mingo_id_in_headers
    headers['mingo_id'] = mingo_id.to_s
  end
end
