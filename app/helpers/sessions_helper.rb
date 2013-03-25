module SessionsHelper
  
  # sign in the user and remember them with a cookie
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  # check if current_user is signed in
  def signed_in?
    !current_user.nil?
  end
  
  # set the current user
  def current_user=(user)
    @current_user = user
  end
  
  # get the current user
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  # check if user passed in is the current user as set above
  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
   unless signed_in?
     store_location
     redirect_to signin_url, notice: "Please sign in." unless signed_in?
   end
  end
    

  # sign out user and delete cookie that remembers them
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # save current location
  def store_location
    session[:return_to] = request.url
  end
  
  # redirect to saved location or default
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
end
