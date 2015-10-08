ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Test the minimum or maximum length of an attribute
  def assert_length(boundry, object, attribute, length, options = {})
    valid_char = options[:valid_char] || "a"
    barely_invalid = barely_invalid_string(boundry, length, valid_char)
    # Test one over the boundary
    object[attribute] = barely_invalid
    assert !object.valid?, "#{object[attribute]} (length #{object[attribute].length}) " +
                             "should raise a length error"

    # Test the boundary itself
    barely_valid = valid_char * length
    object[attribute] = barely_valid
    assert object.valid?, "#{object[attribute]} (length #{object[attribute].length}) " +
                            "should be on the boundary of validity"
  end

  # Create an attribute that is just barely valid.
  def barely_invalid_string(boundary, length, valid_char)
    if boundary == :max
      invalid_length = length + 1
    elsif boundary == :min
      invalid_length = length - 1
    else
      raise ArgumentError, "boundary must be :max or :min"
    end
    valid_char * invalid_length
  end
end
