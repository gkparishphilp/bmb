APP_NAME    = "BmB"
APP_DOMAINS  = ['localhost', 'rippleread.com', 'backmybook.com', 'lvh.me', 'reviewverse.com', 'readerswell.com']

APP_ROUTE_PATHS = Rails.application.routes.routes
APP_SUBDOMAINS = ['www', 'admin', 'mail', 'stage']
SSL_PROTOCOL = Rails.env.production? ? 'https' : 'http'