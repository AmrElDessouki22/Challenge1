# Enable session support in API mode
Rails.application.config.session_store :cookie_store
Rails.application.config.middleware.use ActionDispatch::Cookies
Rails.application.config.middleware.use ActionDispatch::Session::CookieStore, Rails.application.config.session_options
