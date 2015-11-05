require 'test_helper'


class FriendshipTest < ActiveSupport::TestCase
  fixtures :users
  def setup
    @user = users(:valid_user)
    @friend = users(:friend)
  end

  test "test_request" do
    Friendship.request(@user, @friend)
    assert Friendship.exists?(@user, @friend)
    assert_status @user, @friend, 'pending'
    assert_status @friend, @user, 'requested'
  end

  test "test_accept" do
    Friendship.request(@user, @friend)
    Friendship.accept(@user, @friend)
    assert Friendship.exists?(@user, @friend)
    assert_status @user, @friend, 'accepted'
    assert_status @friend, @user, 'accepted'
  end

  test "test_breakup" do
    Friendship.request(@user, @friend)
    Friendship.breakup(@user, @friend)
    assert !Friendship.exists?(@user, @friend)
  end

  private

  # Verify the existence of a friendship with the given status.
  def assert_status(user, friend, status)
    friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
    assert_equal status, friendship.status
  end
end
