class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :resume_session
  helper_method :authenticated?, :current_user, :current_account

  private

  def authenticated?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  def current_account
    Current.account
  end

  def require_authentication
    return if authenticated?

    session[:return_to_after_authenticating] = request.fullpath
    redirect_to new_session_path, alert: "Please sign in to continue."
  end

  def resume_session
    Current.session = Session.find_by(id: cookies.signed[:session_id])
    Current.account = Current.session&.user&.accounts&.find_by(id: session[:account_id]) || Current.user&.accounts&.first
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |record|
      cookies.signed.permanent[:session_id] = { value: record.id, httponly: true, same_site: :lax }
      session[:account_id] = user.accounts.first.id
    end
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_id)
    reset_session
  end
end
