class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  around_filter :scope_current_studio, :studio_time_zone, unless: :devise_controller?

  layout :layout_by_resource

  private

  Warden::Manager.after_set_user scope: :user do |user, auth, opts|
    if user.studio.nil?
      auth.logout
      throw(:warden, message: 'Studio not found. Please contact support.')
    end
  end

  def current_studio
    current_user.studio
  end
  helper_method :current_studio

  def scope_current_studio
    Studio.current_id = current_studio.id
    yield
  ensure
    Studio.current_id = nil
  end

  def studio_time_zone(&block)
    Time.use_zone(current_studio.time_zone, &block) unless current_studio.nil?
  end

  def layout_by_resource
    if user_signed_in?
      'application'
    else
      'auth'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:password, :password_confirmation, :reset_password_token) }
  end
end
