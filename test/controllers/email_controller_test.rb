require 'test_helper'

class EmailControllerTest < ActionController::TestCase
  include ProfileHelper
  fixtures :users, :specs

  def setup
    @user = users(:valid_user)
    @friend = users(:friend)
# Make sure deliveries aren't actually made!
    ActionMailer::Base.delivery_method = :test
  end

  def test_correspond
    authorize @user
    post :correspond, :id => @friend.screen_name,
         :message => {:subject => "Test message",
                      :body => "Dude, this is totally rad!"}
    assert_response :redirect
    assert_redirected_to profile_for(@friend)
    assert_equal "Email sent.", flash[:notice]
    assert_equal 1, @emails.length
  end

  test "should get remind" do
    get :remind
    assert_response :success
  end

end
