class DashboardsController < ApplicationController
  
  def show
    redirect_to "/#{current_user.id}" if params[:id].nil?
  end
  
  def index

  end
  
end
