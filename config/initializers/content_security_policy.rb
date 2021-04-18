# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :none

  policy.font_src    :none
  policy.img_src     :self, "http://www.w3.org/2000/svg"
  policy.object_src  :none

  policy.script_src  :self
  policy.style_src   :self, :unsafe_inline

  # If you are using webpack-dev-server then specify webpack-dev-server host
  policy.connect_src :self,
                      :https,
                      "http://localhost:3035",
                      "ws://localhost:3035",
                      "ws://127.0.0.1:53360/cable" if Rails.env.development? || Rails.env.test?

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Set the nonce only to specific directives
# Rails.application.config.content_security_policy_nonce_directives = %w(script-src)

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
