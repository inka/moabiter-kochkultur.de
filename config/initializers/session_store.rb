# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_moabiter-kochkultur.de_session',
  :secret      => '59c3beb065c0ba8d50a6a82139d5f700331640c98548c81bdb605504b8bf57ed3b0985af0ca39d092807d8cf0414a576d2152a9966495836cf30f0180f4ed835'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
