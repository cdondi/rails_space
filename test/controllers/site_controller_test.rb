require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  def setup
    @controller = SiteController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  test "should get index" do
    get :index
    title = assigns(:title)
    assert_equal "Welcome to RailsSpace!", title
    assert_response :success
    assert_template "index"
  end

  test "should get about" do
    get :about
    title = assigns(:title)
    assert_equal "About RailsSpace", title
    assert_response :success
    assert_template "about"
  end

  test "should get help" do
    get :help
    title = assigns(:title)
    assert_equal "RailsSpace Help", title
    assert_response :success
    assert_template "help"
  end

  # Test the navigation menu before login.
  test "navigation not logged in" do
    get :index
    assert_select "a", :content => /Register/, :attributes => { :href => "/user/register" }
    assert_select "a", :content => /Login/, :attributes => { :href => "/user/login" }
    # Test link_to_unless_current
    assert_no_tag "a", :content => /Home/
  end


end
