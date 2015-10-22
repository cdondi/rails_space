class User < ActiveRecord::Base
  has_one :spec
  has_one :faq
  attr_accessor :remember_me
  attr_accessor :current_password
  attr_accessor :password_confirmation

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
    self.password_confirmation = nil
    self.current_password = nil
  end

  # Return true if the password from params is correct.
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
  end

  # Generate messages for password errors.
  def password_errors(params)
    # Use User model's valid? method to generate error messages
    # for a password mismatch (if any).
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    # The current password is incorrect, so add an error message.
    errors.add(:current_password, "is incorrect")
  end

  # Generate a unique identifier for a user
  def unique_identifier
    Digest::SHA1.hexdigest("#{screen_name}:#{password}")
  end
end
