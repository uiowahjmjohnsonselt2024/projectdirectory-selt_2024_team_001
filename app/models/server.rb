require 'timeout'

class Server < ApplicationRecord
  has_many :user_servers, dependent: :destroy
  has_many :users, through: :user_servers
  has_many :grid_tiles, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :players

  after_create :initialize_grid_unless_seeding

  private

  def player_for_user(user)
    players.find_by(user: user)
  end

  # Initialize a 6x6 grid of tiles for the server
  def initialize_grid(skip_image_generation: false)
    possible_weathers = %w[clear_atmosphere partially_cloudy fully_cloudy stormy hurricane_scarred foggy_atmosphere frozen_atmosphere volcanic_clouds auroral_activity dust_storms]
    possible_environments = %w[terrestrial desert ocean frozen lava gas_giant crystal metallic jungle ruined]

    # Wrap the entire grid generation in a timeout block
    Timeout.timeout(12) do
      (1..6).each do |row|
        (1..6).each do |col|
          weather = possible_weathers.sample
          environment = possible_environments.sample

          prompt = "A sci-fi landscape with #{weather} weather in a #{environment} environment that is viewed from space."

          image_url = if skip_image_generation
                        '/planets/11test.png'
                      else
                        service = OpenaiService.new(prompt: prompt, type: 'image')
                        response = service.call

                        if response.is_a?(Hash)
                          response.dig("data", 0, "url") || '/planets/11test.png'
                        else
                          '/planets/11test.png'
                        end
                      end

          grid_tiles.create!(
            row: row,
            column: col,
            weather: weather,
            environment_type: environment,
            image_url: image_url,
            prompt: prompt
          )
        end
      end
    end
  rescue Timeout::Error
    # Handle what happens if it doesn't finish in 12 seconds
    Rails.logger.error "initialize_grid timed out after 12 seconds."
    # You might want to raise an exception, or leave partially created tiles as is, etc.
    # raise "Initialization of grid timed out"
  end

  def initialize_grid_unless_seeding
    initialize_grid(skip_image_generation: seeding?)
  end

  # Method to detect if the code is running during seeding
  def seeding?
    caller.any? { |line| line.include?('db/seeds.rb') }
  end
end
