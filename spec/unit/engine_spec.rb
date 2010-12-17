require 'spec_helper'

describe "The rails application" do
  it "should include Mingo as one of its engines" do
    Rails.application.railties.engines.map(&:class).should include Mingo::Engine
  end
end
