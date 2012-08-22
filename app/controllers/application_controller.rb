class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
     if resource.sign_in_count == 1
          account_path(resource.account)
        else
       stored_location_for(resource) || dashboard_path(resource)
     end
   end
   
  def current_account
    current_user.account
  end

  protected
    def layout_by_resource
      if devise_controller?
        "public"
      else
        "application"
      end
    end

end
