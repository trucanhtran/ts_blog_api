Devise.setup do |config|
  # The secret key used by Devise. Devise will use `Rails.application.secret_key_base`
  # by default if this is not set explicitly.
  config.secret_key = Rails.application.credentials.dig(:devise, :secret_key) || ENV['DEVISE_SECRET_KEY'] if defined?(Rails.application.credentials)

  # Configure the e-mail address which will be shown in Devise::Mailer.
  config.mailer_sender = 'please-change-me@example.com'

  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # If you want to use JWT for API authentication
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.dig(:devise, :jwt_secret_key) || ENV['DEVISE_JWT_SECRET_KEY'] || Rails.application.secret_key_base
    jwt.dispatch_requests = [
      ['POST', %r{^/api/v1/login$}],
      ['POST', %r{^/api/v1/signup$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/api/v1/logout$}]
    ]
    jwt.expiration_time = 1.day.to_i
    jwt.request_formats = { user: [:json] }
  end

  # ==> Configuration for any authentication mechanism
  # Load other devise modules here if you want. The default scope is :user.
  config.skip_session_storage = [:http_auth]
end
