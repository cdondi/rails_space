require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  fixtures :users, :specs
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"


  def setup
    @user = users(:valid_user)
    @friend = users(:friend)

  end

  def test_reminder
    reminder = UserMailer.reminder(@user)
    assert_equal 'reminders@railsspace.com', reminder.from.first
    assert_equal "Your login information at RailsSpace.com", reminder.subject
    assert_equal @user.email, reminder.to.first
    #assert_match /Screen name: #{@user.screen_name}/, reminder.body
    #assert_match /Password: #{@user.password}/, reminder.body
  end

  def test_message
    user_url = "http://railsspace.com/profile/#{@user.screen_name}"
    reply_url = "http://railsspace.com/email/correspond/#{@user.screen_name}"
    message = Message.new(:subject => "Test message",
                          :body => "Dude, this is totally rad!")
    email = UserMailer.create_message(
        :user => @user,
        :recipient => @friend,
        :message => message,
        :user_url => user_url,
        :reply_url => reply_url
    )
    assert_equal message.subject, email.subject
    assert_equal @friend.email, email.to.first
    assert_equal 'do-not-reply@railsspace.com', email.from.first
    assert_match /#{message.body}/, email.body
    assert_match /#{user_url}/, email.body
    assert_match /#{reply_url}/, email.body
  end


  private

  def read_fixture(action)
    IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
  end

  def encode(subject)
    quoted_printable(subject, CHARSET)
  end
end
