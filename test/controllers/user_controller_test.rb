require 'test_helper'

class UserControllerTest < ActionController::TestCase
  include ApplicationHelper

  def setup
    @controller = UserController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    # This user is initially valid, but we may change its attributes.
    @valid_user = users(:valid_user)
  end

  #test "should get index" do
  #  get :index
  #  assert_response :success
  #end

  #test "should get register" do
  #  get :register
  #  assert_response :success
  #end

  test "registration page" do
    get :register
    title = assigns(:title)
    assert_equal "Register", title
    assert_response :success
    assert_template "register"

    # Test the form and all its tags
    assert_select "form", :attributes => { :action => "/user/register", :method => "post" }

    assert_select "input", :attributes => {
                          :name => "user[screen_name]",
                          :type => "text",
                          :size => User::SCREEN_NAME_SIZE,
                          :maxlength => User::SCREEN_NAME_MAX_LENGTH }

    assert_select "input", :attributes => {
                         :name => "user[email]",
                         :type => "text",
                         :size => User::EMAIL_SIZE,
                         :maxlength => User::EMAIL_MAX_LENGTH }

    assert_select "input", :attributes => {
                         :name => "user[password]",
                         :type => "password",
                         :size => User::PASSWORD_SIZE,
                         :maxlength => User::PASSWORD_MAX_LENGTH }

    assert_select "input", :attributes => { :type => "submit", :value => "Register!" }
  end

  test "registration success" do
    register_new_user
    # Test assignment of user.
    user = assigns(:user)
    assert_not_nil user

    # Test new user in database.
    new_user = User.find_by(screen_name: user.screen_name)
    assert_not_nil new_user

    # Test flash and redirect.
    assert_equal "User #{new_user.screen_name} created!", flash[:notice]
    assert_redirected_to :action => "index"

    # Make sure user is logged in properly
    assert logged_in?
    assert_equal user.id, session[:user_id]
  end

  test "registration failure" do
    post :register, :user => { :screen_name => "aa/noyes", :email => "annoyes@example,com", :password => "sun" }
    assert_response :success
    assert_template "register"
    # Test display of error messages.
    assert_select "div", :attributes => { :id => "errorExplanation",
                                       :class => "errorExplanation" }
    # Assert that each form field has at least one error displaced.
    assert_select "li", :content => /Screen name/
    assert_select "li", :content => /Email/
    assert_select "li", :content => /Password/

    # Test to see that the input fields are being wrapped with the correct div.
    error_div = { :tag => "div", :attributes => { :class => "fieldWithErrors" } }

    assert_select "input", :attributes => { :value => "aa/noyes", :name => "user[screen_name]" }
    assert_select "input", :attributes => { :value => "annoyes@example,com", :name  => "user[email]" }
    assert_select "input", :attributes => { :value => "password", :name  => "user[password]" }
  end

  test "login page" do
    get :login
    title = assigns(:title)
    assert_equal "Log in to RailsSpace", title
    assert_response :success
    assert_template "login"
    assert_select "form", :attributes => { :action => "/user/login", :method => "post" }

    assert_select "input", :attributes => { :name => "user[screen_name]", :type => "text", :size => User::SCREEN_NAME_SIZE }
    assert_select "input", :attributes => { :name => "user[password]", :type => "password", :size => User::PASSWORD_SIZE }
    assert_select "input", :attributes => { :name => "user[remember_me]", :type => "checkbox" }
    assert_select "input", :attributes => { :type => "submit", :value => "Login!" }
  end

 # Test a valid login.
  test "login success" do
    try_to_login @valid_user, :remember_me => "0"
    assert logged_in?
    assert_equal @valid_user.id, session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!", flash[:notice]
    assert_response :redirect
    assert_redirected_to :action => "index"

    # Verify that we're not remembering the user
    user = assigns[:user]
    assert user.remember_me != "1"

    # There should be no cookies set
    assert_nil cookies[:remember_me]
    assert_nil cookies[:authorization_token]
  end

  test "login_success_with_remember_me" do
    try_to_login @valid_user, :remember_me => "1"
    test_time = Time.now
    assert logged_in?
    assert_equal @valid_user.id, session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!", flash[:notice]
    assert_response :redirect
    assert_redirected_to :action => "index"

    # Check cookies and expiration dates
    user = User.find(@valid_user.id)
    time_range = 100 # Microseconds range for time agreement

    # Remember me cookies
    assert_equal "1", cookies[:remember_me]
    #assert_in_delta 10.years.from_now(test_time), cookies[:remember_me].expires, time_range

    # Authorization cookie
    cookie_token = cookies["authorization_token"]
    assert_equal user.authorization_token, cookies[:authorization_token]
    #assert_in_delta 10.years.from_now(test_time), cookie_expires(:authorization_token), time_range
  end

 # Test a login with invalid screen name.
  test "login_failure_with_nonexistent_screen_name" do
    invalid_user = @valid_user
    invalid_user.screen_name = "no such user"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination", flash[:notice]
    # Make sure screen_name will be redisplayed, but not the password.
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end

 # Test a login with invalid password.
  test "login_failure_with_wrong_password" do
    invalid_user = @valid_user
    # Construct an invalid password
    invalid_user.password += "baz"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination", flash[:notice]
    # Make sure screen_name will be redisplayed, but not the password.
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end

  # Test logout
  test "logout" do
    try_to_login @valid_user, :remember_me => "1"
    assert logged_in?
    assert_not_nil cookies[:authorization_token]
    get :logout
    assert_response :redirect
    assert_redirected_to :action => "index", :controller => "site"
    assert_equal "Logged out", flash[:notice]
    assert !logged_in?
    assert_nil cookies[:authorization_token]
  end


  # Test the navigation menu after login.
  test "navigation logged in" do
    authorize @valid_user
    get :index
    assert_select "a", :content => /Logout/, :attributes => { :href => "/user/logout" }
    assert_no_tag "a", :content => /Register/
    assert_no_tag "a", :content => /Login/
  end

  # Test index page for authorized user
  test "index authorized" do
    authorize @valid_user
    get :index
    assert_response :success
    assert_template "index"
  end

 # Test forward back to protected page after login
  test "login_friendly_url_forwarding" do
    user = { :screen_name => @valid_user.screen_name, :password => @valid_user.password }
    friendly_url_forwarding_aux(:login, :index, user)
  end

 # Test forward back to protected page after registration
  test "register_friendly_url_forwarding" do
    friendly_url_forwarding_aux(:register, :index, new_user)
  end

  def friendly_url_forwarding_aux(test_page, protected_page, user)
    get protected_page
    assert_response :redirect
    assert_redirected_to :action => "login"
    post test_page, :user => user
    assert_response :redirect
    assert_redirected_to :action => protected_page
    # Make sure the forwarding url has been cleared
    assert_nil session[:protected_page]
  end

  # Try to log a user in using the login action.
  # Pass :remember_me => "0" or :remember_me => "1" in options
  # to invoke the remember me machinery
  def try_to_login(user, options = {})
    user_hash = { :screen_name => user.screen_name, :password => user.password }
    user_hash.merge!(options)
    post :login, :user => user_hash
  end

  # create a new user object
  def new_user
    user = { screen_name: "newscreenname", email: "valid@example.com", password: "long_enough_password" }
  end

  # Register a new user
  def register_new_user
    post :register, user: new_user
  end

  # Authorize a user
  def authorize(user)
    @request.session[:user_id] = user.id
  end
end
