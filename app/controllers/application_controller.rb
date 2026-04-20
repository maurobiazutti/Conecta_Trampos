class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

   before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    if resource.respond_to?(:profile_incomplete?) && resource.profile_incomplete?
      resource.profile.nil? ? new_profile_path : edit_profile_path
    else
      root_path
    end
  end


end
