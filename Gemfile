source "https://rubygems.org"
ruby "3.3.0"

gem "rails", "~> 7.2.2"
gem "propshaft"
gem "sqlite3", ">= 2.1"

gem "jbuilder"
# Styling: rubocop -a
gem "rubocop"

gem "haml"

gem "bcrypt", "~> 3.1.7"

gem "turbo-rails"

gem "bootsnap", require: false

gem "kamal", require: false

gem "thruster", require: false

gem 'factory_bot_rails'

gem 'devise'

gem 'actioncable'

gem 'stripe-ruby-mock'
#Gem for Payment Processing Third Party Application
gem 'stripe'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "brakeman", require: false

  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "faker"

end

group :development do
  gem "web-console"
end

group :production do
  gem "pg"
  gem "rails_12factor"
  gem 'puma'
end

group :test do
  gem "jasmine-rails"
  gem "byebug"
  gem "launchy"
  gem "rspec", "~>3.5"
  gem "guard-rspec"
  gem "rspec-expectations"
  gem "cucumber-rails", "~> 3.0", require: false
  gem "database_cleaner"
  gem "rails-controller-testing"
  gem "simplecov", "~> 0.22.0"
  gem 'shoulda-matchers', '~> 5.0'
end