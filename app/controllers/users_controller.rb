class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # success
      # call sign_in from SessionsHelper class, which is included via
      # base ApplicationController
      # automatically available to the views 
      sign_in @user
      # populate flash hash with success message
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
end
