require "capybara"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each, type: :system) do
    if ENV["CI"] == "true"
      driven_by :selenium, using: :headless_chrome
    elsif ENV["WSL"]
      # If the tests are being run on windows in WSL, we need to use a remote version of chrome
      # https://gist.github.com/danwhitston/5cea26ae0861ce1520695cff3c2c3315

      # To enable this behaviour run `WSL=true bundle exec rspec` (or set WSL=true in your environment)
      driven_by :selenium, using: :remote, options: { url: "http://localhost:4445/wd/hub", desired_capabilities: :chrome }
    else
      driven_by :selenium, using: :chrome
    end
  end
end
