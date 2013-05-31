# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
#config.action_controller.allow_forgery_protection    = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# used in auth registration mailer
SITE_URL = "http://localhost:3000"

# send cookies only with https session
#ActionController::Base.session_options[:session_secure] = true
