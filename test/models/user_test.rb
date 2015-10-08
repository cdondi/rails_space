require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end

  test "user validity" do
    assert @valid_user.valid?
  end

  test "user invalidity" do
    assert !@invalid_user.valid?
    # TO DO Read about ActiveModel::Errors < Object
    #attributes = [:screen_name, :email, :password]
    #attributes.each do |attribute|
    #  assert @invalid_user.errors.invalid?(attribute)
    #end
  end

  test "uniqueness of screen name and email" do
    user_repeat = User.new(:screen_name => @valid_user.screen_name,
                           :email => @valid_user.email,
                           :password => @valid_user.password)
    assert_not_nil user_repeat
    assert !user_repeat.valid?
  end

 test "screen name length boundaries" do
    assert_length :min, @valid_user, :screen_name, User::SCREEN_NAME_MIN_LENGTH
    assert_length :max, @valid_user, :screen_name, User::SCREEN_NAME_MAX_LENGTH
  end

  test "password length boundaries" do
    assert_length :min, @valid_user, :password, User::PASSWORD_MIN_LENGTH
    assert_length :max, @valid_user, :password, User::PASSWORD_MAX_LENGTH
  end

  test "email maximum length" do
    user = @valid_user
    max_length = User::EMAIL_MAX_LENGTH

    # Email is maximum length.
    user.email = "a" * (max_length - user.email.length) + user.email
    assert user.valid?, "#{user.email} should be just short enough to pass"

    # Construct a valid email that is too long
    user.email = "a" * (max_length - user.email.length + 1) + user.email
    assert !user.valid?, "#{user.email} should raise a maximum length error"
  end

  test "email with valid examples" do
    user = @valid_user
    valid_endings = %w(com org net edu es jp info ac)
    valid_emails = valid_endings.collect do |ending|
      "foo.bar_1-9@baz-quux0.example.#{ending}"
    end
    valid_emails.each do |email|
      user.email = email
      assert user.valid?, "#{email} must be a valid email address"
    end
  end

  test "email with invalid examples" do
    user = @valid_user

    invalid_emails = %w{foobar@example.c @example.com f@com foo@bar..com
                        foobar@example.infod foobar.example.com
                        foo,@example.com foo@ex(ample.com foo@example,com}
    invalid_emails.each do |email|
      user.email = email
      assert !user.valid?, "#{email} tests as valid but shouldn't be"

      # TO DO :
      # assert_equal "must be a valid email address", user.errors.on(:email)
    end
  end

  test "screen name with valid examples" do
    user = @valid_user
    valid_screen_names = %w{aure michael web_20}
    valid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert user.valid?, "#{screen_name} should pass validation, but doesn't"
    end
  end

  test "screen name with invalid examples" do
    user = @valid_user
    invalid_screen_names = %w{rails/rocks web2.0 javascript:something}
    invalid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert !user.valid?, "#{screen_name} shouldn't pass validation, but does"
    end
  end

end
