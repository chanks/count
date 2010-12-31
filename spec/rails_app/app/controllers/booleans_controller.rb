class BooleansController < ApplicationController
  def test
    render :text => ab_test("Boolean Test").to_s
  end
end
