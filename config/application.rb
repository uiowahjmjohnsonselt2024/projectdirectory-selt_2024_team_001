require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShardsOfTheGrid
  class Application < Rails::Application
    config.load_defaults 7.2
    config.action_cable.mount_path = '/cable'
  end
end

