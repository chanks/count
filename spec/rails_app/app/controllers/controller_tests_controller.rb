class ControllerTestsController < ApplicationController
  def test
    send params[:id]
  end

  private

  def boolean
    render :text => ab_test('boolean_test').to_s
  end

  def boolean_bingo
    bingo! 'boolean_test'
    render :text => 'nil'
  end
end
