source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.4", ">= 6.1.4.4"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.3"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.2.1"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "bugsnag"
gem "factory_bot_rails"
gem "ffaker"
gem "rubocop"
gem "rubocop-daemon"
gem "sidekiq"
gem "skylight"
gem "stimulus_reflex"

group :development, :test do
  gem "rspec_junit_formatter"
  gem "rspec-rails"
end

gem "lockbox"

gem "kms_encrypted"

gem "aws-sdk-kms"

gem "dotenv-rails"

gem "view_component", require: "view_component/engine"

gem "ocl_tools", git: "https://github.com/oxfordtogether/ocl_tools.git", ref: "1b273e0"
# gem "ocl_tools", path: "../ocl_tools"

gem "auth0"
gem "omniauth-auth0", "~> 2.2"
gem "omniauth-rails_csrf_protection", "~> 0.1"

gem "hiredis"
gem "redis"

gem "pagy"

gem "google_drive"

gem "groupdate"

gem "lograge"

gem "mailgun-ruby", "~>1.1.6"

gem "rack-attack"

group :development do
  gem "htmlbeautifier", git: "https://github.com/jeremyf/htmlbeautifier", ref: "4d4467f"
  gem "solargraph"
end

gem "wicked_pdf", git: "https://github.com/mileszs/wicked_pdf", ref: "2dc96dd"

group :production do
  gem "wkhtmltopdf-heroku", "2.12.6.0"
end

group :development do
  gem "wkhtmltopdf-binary-edge"
end

gem "no_cache_control"
