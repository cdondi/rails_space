class FriendshipController < ApplicationController
  include ProfileHelper
  before_filter :protect, :setup_friends
# Send a friend request.
# We'd rather call this "request", but that's not allowed by Rails.
  def create
    Friendship.request(@user, @friend)
    UserMailer.deliver_friend_request(
        :user => @user,
        :friend => @friend,
        :user_url => profile_for(@user),
        :accept_url => url_for(:action => "accept", :id => @user.screen_name),
        :decline_url => url_for(:action => "decline", :id => @user.screen_name)
    )
    flash[:notice] = "Friend request sent."
    redirect_to profile_for(@friend)
  end


  private

  
  def setup_friends
    @user = User.find(session[:user_id])
    @friend = User.find_by_screen_name(params[:id])
  end
end

