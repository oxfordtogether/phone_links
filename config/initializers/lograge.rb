Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    {
      params: event.payload[:params].reject { |k| %w[controller action].include? k },
    }
  end

  config.lograge.custom_payload do |controller|
    {
      auth0_id: controller.try(:current_auth0_id),
    }
  end
end
