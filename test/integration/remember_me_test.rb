require 'test_helper'

class RememberMeTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  fixtures :users

  def setup
    @user = users(:valid_user)
  end

  test "the truth" do
     assert true
  end

  test "remember_me" do
    # Log in with "remember me" enabled
    post "/user/login", :user => { :screen_name => @user.screen_name,
                                  :password => @user.password,
                                  :remember_me => "1"}
    # Simulate "closing the browser" by clearing the user id from the session
    @request.session[:user_id] = nil
    # Now access an arbitrary page.
    get "/site/index"
    # The check_authorization before_filter should have logged us in
    assert logged_in?
    assert_equal @user.id, session[:user_id]
  end
end
