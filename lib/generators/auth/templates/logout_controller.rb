class LogoutController < ApplicationController
  skip_before_action :logged_in_using_omniauth?

  def logout
    reset_session

    redirect_to logout_url.to_s
  end

  private

  def logout_url
    domain = Rails.application.config_for(:auth0).domain
    client_id = Rails.application.config_for(:auth0).client_id

    request_params = {
      returnTo: root_url,
      client_id: client_id,
    }

    URI::HTTPS.build(host: domain, path: "/v2/logout", query: to_query(request_params))
  end

  def to_query(hash)
    hash.map { |k, v| "#{k}=#{CGI.escape(v)}" unless v.nil? }.reject(&:nil?).join("&")
  end
end
