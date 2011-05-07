require 'rails/spec_helper'

describe "The rails application" do
  it "should include Count as one of its railties" do
    Rails.application.railties.railties.map(&:class).should include Count::Railtie
  end
end
