class Auth0Controller < ApplicationController
  skip_before_action :logged_in_using_omniauth?

  def callback
    auth_details = request.env["omniauth.auth"]
    redirect_to "/" unless auth_details

    email_verified = session[:email_verified] = auth_details.dig(:extra, :raw_info, :email_verified)
    email = session[:email] = auth_details.dig(:info, :email)
    auth0_id = session[:auth0_id] = auth_details[:uid]

    if auth0_id.nil?
      redirect_to "/"
      return
    end

    # first we want to see if we can find the person
    person = Person.where(auth0_id: auth0_id).first

    # if there isn't a person, try to find one to link to
    if !person && email && email_verified
      person = Person.all.find { |p| p.email.present? && clean_email(p.email) == email }
      person&.update!(auth0_id: auth0_id)
    end

    # now try to find a role
    if person
      session[:person_id] = person.id
    end

    redirect_to "/"
  end

  def failure
    # show a failure page or redirect to an error page
    @error_msg = request.params["message"]
  end

  private

  def clean_email(email)
    email.downcase.strip if email.present?
  end
end
