#-*- coding: utf-8 -*-
source 'https://rubygems.org'

# Heroku
ruby '2.0.0'

# Core Components
gem 'rails', '4.0.0'
gem 'jquery-rails'

# Assets
gem 'less-rails'
gem 'haml-rails'
gem 'sass'
gem 'haml'
gem 'less'
gem 'therubyracer', :platform => :ruby # required for LESS
gem 'coffee-rails', '~> 4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'bourbon'
gem 'protected_attributes'

# Libraries
gem 'devise'
gem 'rufus-scheduler'

group :production do
  gem 'thin'
  gem 'pg'
  gem 'rails_12factor'
  gem 'rails_serve_static_assets'
end

group :test, :development do
  gem 'sqlite3'
  gem 'debugger'
end

# ------------------------------------------------------------------------------
# Rails 4 stuff

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development
