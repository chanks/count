class ViewTestsController < ApplicationController
  def test
    render :template => params[:id], :layout => nil
  end
end
