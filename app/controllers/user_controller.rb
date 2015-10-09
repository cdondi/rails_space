require 'digest/sha1'

class UserController < ApplicationController
  include ApplicationHelper

  before_filter :protect, :only => :index

  def index
    #@user = User.find(session[:user_id])
    @title = "RailsSpace User Hub"
  end

  def register
    @title = "Register"
    if request.post? and user_params
      #logger.info "------------------ START USER PARAMS ----------------------"
      #logger.info user_params.inspect
      #logger.info "------------------    END USER PARAMS ----------------------"
      @user = User.new(user_params)
      if @user.save
        logger.info "--------------- USER #{@user.screen_name} CREATED! ------------------"
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
  end

  def login
    @title = "Log in to RailsSpace"
    if request.get?
      @user = User.new(:remember_me => remember_me_string)
    elsif request.post? and user_params
      @user = User.new(user_params)
      user = User.find_by(:screen_name => @user.screen_name, :password => @user.password)

      if user
        user.login!(session)

        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)

        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to_forwarding_url
      else
        # Don't show the password in the view
        @user.clear_password!
        flash[:notice] = "Invalid screen name/password combination"
      end
    end
  end

  def logout
    User.logout!(session, cookies)
    flash[:notice] = "Logged out"
    redirect_to :action => "index", :controller => "site"
  end

  def user_params
    params.require(:user).permit(:screen_name, :email, :password, :remember_me)
  end

  def remember_me_string
    cookies[:remember_me] || 0
  end

  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to action: "index"
    end
  end

  # Protect a page from unauthorized access
  def protect
    unless logged_in?
      session[:protected_page] = request.url
      flash[:notice] = "Please login first"
      redirect_to :action => "login"
      return false
    end
  end
end