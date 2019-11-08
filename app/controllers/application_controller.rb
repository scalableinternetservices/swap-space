class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ItemsHelper

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
    def sorted_items(items)
      # items should be of type Item.all
      list = items
      # Filtering should be a TODO
      # if params["id"].present?
      #   list = Item.where(["user_id = :id", {id: params[:id]}])
      # else
      #   list = Item.all
      # end
      if params['sort'].present?
        attribute = params['sort']
        # default order is descending
        order = params['order'].present? ? params['order'] : 'desc'
        return item_sort(list, attribute, order == 'desc')
      end 
      return list
    end
end
