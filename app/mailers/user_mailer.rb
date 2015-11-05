class UserMailer < ApplicationMailer
  default from: 'reminders@railsspace.com'

  def reminder(user)
    @user = user
    @subject = 'Your login information at RailsSpace.com'
    @body = {}
    # Give body access to the user information.
    @body["user"] = user
    @recipients = user.email
    @from = 'RailsSpace <do-not-reply@railsspace.com>'
    mail(to: @recipients, subject: @subject)
  end

  def correspond(user,recipient, message, userurl)
    @user = user
    @recipient = recipient.email
    #@from = 'do-not-reply@railsspace.com'
    #@body = {}
    #@body["user"] = @user
    @message = message
    @user_url = userurl
    @reply_url = url_for(:action => "correspond", :id => user.screen_name, :controller => "user")
    mail(to: @recipient)
  end

  def friend_request(user, friend, user_url, accept_url, decline_url)
    @user = user
    @friend = friend
    subject = 'New friend request at RailsSpace.com'
    from = 'RailsSpace <do-not-reply@railsspace.com>'
    recipients = friend.email
    #body mail
    @user_url = user_url
    @accept_url = accept_url
    @decline_url = decline_url
    mail(to: recipients, subject: subject, from: from )
  end
end
