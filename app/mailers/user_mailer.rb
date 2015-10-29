class UserMailer < ApplicationMailer
  def reminder(user)
    @subject = 'Your login information at RailsSpace.com'
    @body = {}
    # Give body access to the user information.
    @body["user"] = user
    @recipients = user.email
    @from = 'RailsSpace <do-not-reply@railsspace.com>'
  end

  # TODO : Add code to send the actual reminder
  def deliver_reminder(user)

  end
end
