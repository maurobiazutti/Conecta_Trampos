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
    return super unless resource.is_a?(User)

    next_onboarding_step_for(resource, fallback: root_path)
  end

  def after_sign_up_path_for(resource)
    next_onboarding_step_for(resource, fallback: super)
  end

  private

  def onboarding_path_for(user)
    return user.profile.nil? ? new_profile_path : edit_profile_path if user.profile_incomplete?
    return user.address.nil? ? new_address_path : edit_address_path if user.address_incomplete?

    nil
  end

  def next_onboarding_step_for(user, fallback:)
    onboarding_path_for(user) || consume_post_onboarding_path || fallback
  end

  def store_post_onboarding_path(path)
    session[:post_onboarding_path] = path
  end

  def consume_post_onboarding_path
    session.delete(:post_onboarding_path)
  end
end
