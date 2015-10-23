module ApplicationHelper

  # Return a link for use in layout navigation
  def nav_link(text, controller, action="index")
    return link_to_unless_current text, :id => nil,
                                        :controller => controller,
                                        :action => action
  end

  def logged_in?
    not session[:user_id].nil?
  end

  # Check for a valid authorization cookie, possibly logging the user in
  def check_authorization
    authorization_token = cookies[:authorization_token]

    if authorization_token and not logged_in?
      user = User.find_by( :authorization_token => authorization_token)
      user.login!(session) if user
    end
  end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  def text_field_for(form, field, size=HTML_TEXT_FIELD_SIZE, maxlength=DB_STRING_MAX_LENGTH)
    label = content_tag(:label, "#{field.humanize}:", :for => field)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "form_now")
  end
end
