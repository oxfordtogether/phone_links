module Login
  def mock_auth0_success(user = nil, email_verified = true)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    opts = {
      "uid": user&.auth0_id || "user-123",
      "info": {
        "email": user&.email || "user@user.com",
        "first_name": user&.first_name || "Bob",
        "last_name": user&.last_name || "Userman",
      },
      "extra": {
        "raw_info": {
          "email_verified": email_verified,
        },
      },
      "credentials": {
        "token": "XKLjnkKJj7hkHKJkk",
        "expires": true,
        "id_token": "eyJ0eXAiOiJK1VveHkwaTFBNXdTek41dXAiL.Wz8bwniRJLQ4Fqx_omnGDCX1vrhHjzw",
        "token_type": "Bearer",
      },
    }

    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(opts)
  end

  def mock_auth0_failed
    OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
  end

  def login_as(user = nil, invalid: false, email_verified: true)
    invalid ? mock_auth0_failed : mock_auth0_success(user, email_verified)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]

    visit "/auth/auth0/callback?code=vihipkGaumc5IVgs"
  end
end

RSpec.configure do |config|
  # include our macro
  config.include Login, type: :system
end

OmniAuth.config.test_mode = true
# just a comment
