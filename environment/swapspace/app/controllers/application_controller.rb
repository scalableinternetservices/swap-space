class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    # confirm currently user is logged in
    def logged_in_user
      unless logged_in?
        # return to current page after logging in
        # store_locatiod
        flash[:danger] = 'Please Log in'
        redirect_to login_url
      end
    end
end
