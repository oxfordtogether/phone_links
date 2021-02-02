class AuthGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create
    copy_file "auth0_controller.rb", "app/controllers/auth0_controller.rb"
    copy_file "login_controller.rb", "app/controllers/login_controller.rb"
    copy_file "logout_controller.rb", "app/controllers/logout_controller.rb"

    copy_file "secured.rb", "app/controllers/concerns/secured.rb"

    copy_file "auth0.rb", "config/initializers/auth0.rb"
    copy_file "auth0.yml", "config/auth0.yml"

    copy_file "invalid_permissions.html.erb", "app/views/login/invalid_permissions.html.erb"
    copy_file "login_show.html.erb", "app/views/login/show.html.erb"
    copy_file "unauthorized.html.erb", "app/views/layouts/unauthorized.html.erb"

    copy_file "login_spec.rb", "spec/system/login_spec.rb"
    copy_file "logout_spec.rb", "spec/system/logout_spec.rb"
    copy_file "spec_support_login.rb", "spec/support/login.rb"
  end
end
