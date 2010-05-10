# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ecclesia_session',
  :secret      => '1351061005e55059fc991ac7ecb02aeb946ac3435f4bbb9a3772bbf61ee0a3ce4a14a723802368ef03cf941e6a64dd708aef79ff5d34d7daf069ebdb8a51c63d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
