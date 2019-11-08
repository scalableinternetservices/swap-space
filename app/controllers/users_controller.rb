class UsersController < ApplicationController
  include ItemsHelper
  def show 
    @user = User.find(params[:id])
    users_item = Item.where(["user_id = :id", {id: params[:id]}])
    @user_items = sorted_items(users_item)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle a successful save.
      log_in @user
      flash[:success] = 'Welcome to SwapSpace!'
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
