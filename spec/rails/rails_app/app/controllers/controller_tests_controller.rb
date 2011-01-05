class ControllerTestsController < ApplicationController

  def test
    render :text => ab_test(:boolean)
  end

  def bingo
    bingo! :boolean
    render :nothing => true
  end

end
