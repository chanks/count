class BooleansController < ApplicationController
  def test
    render :text => ab_test('boolean_controller_test').to_s
  end
end
