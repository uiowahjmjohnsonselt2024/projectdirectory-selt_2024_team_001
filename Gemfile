source 'https://rubygems.org'

ruby '2.6.10'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Haml as the templating library
gem 'haml'

# Use sqlite3 only in development and test environments
group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
end

# Use PostgreSQL in production
group :production do
  gem 'pg', '~> 0.2'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# For interacting with the GitHub API
gem 'octokit'
# For programmatically creating and manipulating Cucumber features
gem 'cuke_modeler'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.16'

# Debugging and testing tools
group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'database_cleaner' # Ensure only one entry
  gem 'cucumber-rails', require: false # Ensure only one entry
  gem 'rspec-rails'
end

group :test do
  gem 'rspec-expectations'
end

# Code coverage
gem "simplecov", "~> 0.22.0"
