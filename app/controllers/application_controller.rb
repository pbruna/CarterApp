class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || users_path
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
