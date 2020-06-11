source "https://rubygems.org"
ruby '2.6.2'
source "https://gems.shefcompsci.org.uk" do
  gem 'airbrake'
  gem 'rubycas-client'
  gem 'epi_deploy', group: :development
  gem 'capybara-select2', group: :test
  gem 'epi_js'
  gem 'epi_cas'
end

gem 'rails', '6.0.0'
gem 'activerecord-session_store'
gem 'bootsnap'
gem 'responders'
gem 'thin'

gem 'sqlite3', '1.4.1', group: [:development, :test]
gem 'pg'

gem 'haml-rails'
gem 'sassc-rails'
gem 'sassc', '2.2.0' # 2.2.1 is currently broken on LTSP
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'bootstrap', '~> 4.4.1'
gem 'font-awesome-sass', '~> 5.9.0'
# select2-rails is vendored under vendor/assets

gem 'simple_form'
gem 'draper'
gem 'ransack'

gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'devise_cas_authenticatable'
gem 'cancancan'

gem 'whenever'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed-plugins-airbrake'
gem 'daemons', '1.1.9'

# Dynamic adding/removing of associations
gem 'cocoon'
# Audit log
gem "audited", "~> 4.9"
# Select2 for simple form
gem 'select2_simple_form', github: 'lndl/select2_simple_form', tag: '0.7.3'

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug'
end

group :development do
  gem 'listen'
  gem 'web-console'

  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false

  gem 'eventmachine'
  gem 'letter_opener'
  gem 'annotate'
end

group :test do
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'webdrivers'
  gem 'rspec-instafail', require: false

  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'

  # Needed for controller testing
  gem 'rails-controller-testing'
end
