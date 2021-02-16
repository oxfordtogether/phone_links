class Auth0Controller < ApplicationController
  skip_before_action :logged_in_using_omniauth?

  def callback
    # This stores all the user information that came from Auth0
    # and the IdP
    session[:userinfo] = request.env["omniauth.auth"]

    person = Person.where(auth0_id: session[:userinfo]["uid"]).first
    session[:person_id] = person ? person.id : nil
    session[:admin_id] = person&.admin&.active ? person.admin.id : nil
    session[:pod_leader_id] = person&.pod_leader&.active ? person.pod_leader.id : nil
    session[:caller_id] = person&.caller&.active ? person.caller.id : nil

    # Redirect to the URL you want after successful auth
    redirect_to "/"
  end

  def failure
    # show a failure page or redirect to an error page
    @error_msg = request.params["message"]
  end
end
