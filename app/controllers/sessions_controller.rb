class SessionsController < ApplicationController
  def new 
  end
  
  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
    #  sign in and redirect to user's show page
      sign_in user
      redirect_back_or user
    else
      #create error message and re-render signin form
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
