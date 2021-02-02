class Auth0Controller < ApplicationController
  skip_before_action :logged_in_using_omniauth?

  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    session[:userinfo] = request.env["omniauth.auth"]

    # This may need to be configured depending on use case
    person = Person.where(auth0_id: session[:userinfo]["uid"]).first
    session[:person_id] = person.id if person

    # Redirect to the URL you want after successful auth
    redirect_to "/"
  end

  def failure
    # show a failure page or redirect to an error page
    @error_msg = request.params["message"]
  end
end
