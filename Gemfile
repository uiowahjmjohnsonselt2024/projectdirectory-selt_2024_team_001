source 'https://rubygems.org'

ruby '2.6.10'

# Core Rails components
gem 'rails', '4.2.10'

# Use PostgreSQL for production
group :production do
  gem 'pg', '~> 0.2'
end

# Use SQLite3 for development and test environments
group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'byebug'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
  gem 'rspec-rails'
end

# General-purpose gems
gem 'bcrypt', '~> 3.1.16'            # For secure password hashing
gem 'haml'                           # For HAML templates
gem 'sass-rails', '~> 5.0.3'         # SCSS for stylesheets
gem 'uglifier', '>= 2.7.0'           # JavaScript asset compression
gem 'coffee-rails', '~> 4.1.0'       # Use CoffeeScript for JS
gem 'jquery-rails'                   # Use jQuery for JavaScript
gem 'jbuilder', '~> 2.0'             # Build JSON APIs
gem 'sdoc', '~> 0.4.0', group: :doc  # API documentation generator

# GitHub integration
gem 'octokit'

# Cucumber testing utilities
gem 'cuke_modeler'

# Code coverage
gem 'simplecov', '~> 0.22.0'

# Testing group
group :test do
  gem 'rspec-expectations'
end
