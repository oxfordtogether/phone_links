module Login
  def mock_auth0_success(_user = nil, tenants = [], permissions = [])
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    opts = {
      "uid": "user-123",
      "info": {
        "email": "user@user.com",
        "first_name": "Bob",
        "last_name": "Userman",
      },
      "credentials": {
        "token": "XKLjnkKJj7hkHKJkk",
        "expires": true,
        "id_token": "eyJ0eXAiOiJK1VveHkwaTFBNXdTek41dXAiL.Wz8bwniRJLQ4Fqx_omnGDCX1vrhHjzw",
        "token_type": "Bearer",
      },
      "extra": {
        "raw_info": {
          "https://oxfordtogether.org/claims/permissions": permissions,
          "https://oxfordtogether.org/claims/app_metadata": {
            "authorization": {
              "tenants": tenants,
            },
          },
        },
      },
    }

    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(opts)
  end

  def mock_auth0_failed
    OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
  end

  def login_as(user = nil, invalid: false, tenants: ["...app-tennant..."], permissions: ["...access:permissions..."])
    invalid ? mock_auth0_failed : mock_auth0_success(user, tenants, permissions)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]

    visit "/auth/auth0/callback?code=vihipkGaumc5IVgs"
  end
end

RSpec.configure do |config|
  # include our macro
  config.include Login, type: :system
end

OmniAuth.config.test_mode = true
