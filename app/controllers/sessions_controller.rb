class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new; end

  def create
    user = User.authenticate_by(email_address: params[:email_address], password: params[:password])

    if user
      start_new_session_for(user)
      redirect_to session.delete(:return_to_after_authenticating) || dashboard_path
    else
      redirect_to new_session_path, alert: "Invalid email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "You have been signed out."
  end
end
