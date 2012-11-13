# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_accounts!
  
  include LocaleSetter::Rails
  
  def after_sign_in_path_for(resource)
     if resource.sign_in_count == 1
          account_path(resource.account)
        else
       stored_location_for(resource) || dashboards_path(resource)
     end
   end
   
  def current_account
    current_user.account
  end
  
  def block_inactive_accounts!
    return if devise_controller?
    unless current_account.active?
      redirect_to account_path(current_account)
      link = '<a href="#select-plan">seleccione un plan</a>'
      flash[:error] = "Su periodo de prueba terminó, por favor #{link}.".html_safe
    end
  end

  protected
    def layout_by_resource
      return "application" if current_user
      "public"
    end

end
