class MingoIdOverridesController < ApplicationController

  def test
    render :text => ab_test('override')
  end

  def bingo
    bingo! 'override'
    render :nothing => true
  end

  private

  def mingo_id
    Digest::MD5.hexdigest(params[:id])
  end
end
