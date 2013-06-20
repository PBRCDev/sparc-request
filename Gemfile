source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'haml'
gem 'sass'

group :development, :test, :profile do
  gem "rails-erd"
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'launchy'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'faker'
  gem 'timecop'
  gem 'debugger'
  gem 'quiet_assets'
  gem 'connection_pool'
  gem 'thin'
  gem 'equivalent-xml'

  # Add dependency on poltergeist.  If you want to use poltergeist, you
  # will need to configure Capybara to use it.  This particular
  # poltergeist repository is for Capybara 2.0 support.  Poltergeist
  # should official support Capybara 2.0 after Dec. 20.
  gem 'poltergeist' #, :git => 'git://github.com/brutuscat/poltergeist.git'

  # You can put gems in here that you want to use for development but
  # don't want to force on other developers (e.g. rubyception).
  if File.exists?('Gemfile.devel') then
    eval File.read('Gemfile.devel'), nil, 'Gemfile.devel'
  end
end

# these are needed for the import script
group :import do
  # gem 'alfresco_handler', :path => '../alfresco_handler'
  gem 'progress_bar'
  gem 'mustache'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'inflection-js-rails'
end

gem 'cache_digests'
gem 'dynamic_form'

#gem 'obis-bridge', :path => '../obis-bridge' this now lives within the application
# yanked from obis-bridge
gem 'json'
gem 'sinatra'
gem 'grouped_validations'
gem 'obis-net-ldap'
gem 'paperclip'
gem 'acts_as_list', '0.1.9'
# gem "paper_trail", "~> 2"
gem 'devise'
gem 'omniauth'
gem 'omniauth-shibboleth'
# end obis-bridge gems

# yanked from sparc-services
gem "nested_form"
gem 'jquery-rails', "2.1.3"

group :development, :test do
  gem 'turn', :require => false
  gem 'jasmine'
  gem 'addressable', '~> 2.3.2'
  gem 'watchr'
  gem 'nyan-cat-formatter'
  gem 'capybara-firebug'
end

group :development do
  gem 'highline'
end
# end sparc-services gems

gem 'will_paginate'

# requirements for excel export
gem 'axlsx'
gem 'axlsx_rails'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'
gem 'rvm-capistrano'

group :profile do
  gem 'ruby-prof'
end

gem 'exception_notification'
gem 'letter_opener'

gem 'prawn'
gem 'acts-as-taggable-on', '~> 2.3.1'

gem 'savon', '~> 2.2.0'    # SOAP client
gem 'gyoku'                # XML builder
gem 'nori', '~> 2.1.0'     # XML parser
