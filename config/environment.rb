# Load the Rails application.
require File.expand_path('../application', __FILE__)
require 'will_paginate/array'

# Initialize the Rails application.
Rails.application.initialize!

DB_STRING_MAX_LENGTH = 255
DB_TEXT_MAX_LENGTH = 40000
HTML_TEXT_FIELD_SIZE = 15

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 25,
    :domain => "railsspace.com",
    :authentication => :login,
    :user_name => "username@gmail.com",
    :password => "password",
}

