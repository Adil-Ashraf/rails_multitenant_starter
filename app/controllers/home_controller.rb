class HomeController < ApplicationController
  def show
    redirect_to dashboard_path if authenticated?
  end
end
