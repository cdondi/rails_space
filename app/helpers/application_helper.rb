module ApplicationHelper

  # Return a link for use in layout navigation
  def nav_link(text, controller, action="index")
    return link_to_unless_current text, :controller => controller, :action => action
  end

  def logged_in?
    not session[:user_id].nil?
  end

  # Check for a valid authorization cookie, possibly logging the user in
  def check_authorization
    authorization_token = cookies[:authorization_token]

    if authorization_token and not logged_in?
      user = User.find_by( :authorization_token => authorization_token)
      user.login!(session) if user
    end
  end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
end
