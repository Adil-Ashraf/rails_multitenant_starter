class RegistrationsController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    Account.transaction do
      @user.save!
      account = Account.create!(name: params[:account_name], slug: unique_slug(params[:account_name]))
      Membership.create!(user: @user, account:, role: :owner)
    end

    start_new_session_for(@user)
    redirect_to dashboard_path, notice: "Welcome! Your workspace is ready."
  rescue ActiveRecord::RecordInvalid => error
    @user.errors.add(:base, error.record.errors.full_messages.to_sentence) unless error.record.equal?(@user)
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.expect(user: %i[name email_address password password_confirmation])
  end

  def unique_slug(name)
    base = name.to_s.parameterize.presence || "workspace"
    candidate = base
    candidate = "#{base}-#{SecureRandom.hex(3)}" while Account.exists?(slug: candidate)
    candidate
  end
end
