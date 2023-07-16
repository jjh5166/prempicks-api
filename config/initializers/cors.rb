# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('ALLOWED_ORIGINS') || raise("Missing env variable ALLOWED_ORIGINS")

    resource '/api/*',
            headers: :any,
            methods: %i[get post put patch delete options head]
    resource '/rails/*',
            headers: :any,
            methods: %i[get post put patch delete options head]
  end

  allow do
    origins '*'

    resource '/sidekiq/*', headers: :any, methods: :get
  end
end
