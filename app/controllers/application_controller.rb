class ApplicationController < ActionController::Base


  include ApplicationHelper
  before_filter :check_authorization


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Protect a page from unauthorized access
  def protect
    unless logged_in?
      session[:protected_page] = request.url
      flash[:notice] = "Please login first"
      redirect_to :controller => "user", :action => "login"
      return false
    end
  end
end
