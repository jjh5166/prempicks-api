# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Unicorn as the app server
gem 'unicorn'
# heroku recommended, produces stack traces for debug
gem 'rack-timeout'
# sidekiq background jobs
gem 'sidekiq'
# sidekiq scheduler
gem 'sidekiq-scheduler'
# read firebase id tokens
gem 'firebase_id_token', '~> 2.4.0'
# redis server
gem 'redis'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
# read .env file
gem 'dotenv-rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
# use httparty for requests
gem 'httparty'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'foreman'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :production do
  gem 'scout_apm'
end

group :development do
  gem 'listen', '~> 3.2'
end
