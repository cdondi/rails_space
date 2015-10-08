class User < ActiveRecord::Base
  attr_accessor :remember_me

  # Max and min lengths for all fields
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  # Text box sizes for display in the views
  SCREEN_NAME_SIZE = 20
  PASSWORD_SIZE = 10
  EMAIL_SIZE = 30

  validates_uniqueness_of :screen_name, :email
  validates_length_of     :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of     :password, :within => PASSWORD_RANGE
  validates_length_of     :email, :maximum => EMAIL_MAX_LENGTH
  validates_format_of     :screen_name,
                          :with => /\A[a-zA-Z0-9]+\z/,
                          :message => "must contain only letters, numbers, and underscores"
  validates_format_of     :email,
                          :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                          :message => "must be a valid email address"


=begin
  def valid_screen__name_and_email
    errors.add(:email, "must be valid.") unless email.include? ("@")
    if screen_name.include?(" ")
      errors.add(:screen_name, "cannot include spaces.")
    end
  end
=end

  def remember!(cookies)
    cookies[:remember_me] = { value: "1", expires: 10.years.from_now }
    self.authorization_token = unique_identifier
    self.save!
    cookies[:authorization_token] = { :value => authorization_token, expires: 10.years.from_now }
  end

  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  def remember_me?
    remember_me == "1"
  end

  # Log a user out.
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end

  def login!(session)
    session[:user_id] = self.id
  end

  def clear_password!
    self.password = nil
  end

  # Generate a unique identifier for a user
  def unique_identifier
    Digest::SHA1.hexdigest("#{screen_name}:#{password}")
  end
end
