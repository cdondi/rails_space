require 'digest/sha1'

class UserController < ApplicationController
  include ApplicationHelper
  helper :profile, :avatar
  before_filter :protect, :only => [:index, :edit]

  def index
    @title = "RailsSpace User Hub"
    @user = User.find(session[:user_id])
    @spec = @user.spec ||= Spec.new
    @faq = @user.faq ||= Faq.new
  end

  # Edit the user's basic info.
  def edit
    @title = "Edit basic info"
    @user = User.find(session[:user_id])

    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
        when "email"
          try_to_update @user, attribute
        when "password"
          # Handle password submission
          if @user.correct_password?(params)
            try_to_update @user, attribute
          else
            @user.password_errors(params)
          end
      end
    end

    # For security purposes, never fill in password fields
    @user.clear_password!
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

  # Try to update the user, redirect if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
      flash[:notice] = "User #{attribute} updated."
      redirect_to :action => "index"
    end
  end


end
