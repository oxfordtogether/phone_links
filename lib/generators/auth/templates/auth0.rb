Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.config_for(:auth0).client_id,
    Rails.application.config_for(:auth0).client_secret,
    Rails.application.config_for(:auth0).domain,
    callback_path: "/auth/auth0/callback",
    authorize_params: {
      scope: "openid email profile",
    },
  )
end
