class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    # confirm currently user is logged in
    def logged_in_user
      unless logged_in?
        # return to current page after logging in
        store_location
        flash[:danger] = 'Please Log in'
        redirect_to login_url
      end
    end

    #sort items by query params
    def sorting
      # Filtering is not done and should be a TODO
      # if params["id"].present?
      #   list = Item.where(["user_id = :id", {id: params[:id]}])
      # else
      #   list = Item.all
      # end
      if params["sort"].present?
          attribute = params["sort"]
          if params["order"].present?
            order = params["order"]
          else
            order = "asc"
          end
          session[:order] = params["order"]
          if attribute == "popularity"
            if params["order"] == "asc"
              return list.sort_by(&:popularity)
            else
             return list.sort_by(&:popularity).reverse
            end
          else
            return list.order(attribute => order)
          end
        else
          return list
      end
  end
end
