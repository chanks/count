require 'rails/spec_helper'

describe "The rails application" do
  it "should include Mingo as one of its railties" do
    Rails.application.railties.railties.map(&:class).should include Mingo::Railtie
  end
end
