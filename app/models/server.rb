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
  # Now done in two phases:
  # 1. Create all tiles with placeholder images
  # 2. (Optional) Attempt to generate images with OpenAI, wrapped in a timeout
  def initialize_grid(skip_image_generation: false)
    possible_weathers = %w[clear_atmosphere partially_cloudy fully_cloudy stormy hurricane_scarred foggy_atmosphere frozen_atmosphere volcanic_clouds auroral_activity dust_storms]
    possible_environments = %w[terrestrial desert ocean frozen lava gas_giant crystal metallic jungle ruined]

    # Phase 1: Create tiles with placeholder images
    created_tiles = []
    (1..6).each do |row|
      (1..6).each do |col|
        weather = possible_weathers.sample
        environment = possible_environments.sample
        prompt = "A sci-fi landscape with #{weather} weather in a #{environment} environment that is viewed from space."

        # Initially set a placeholder image
        tile = grid_tiles.create!(
          row: row,
          column: col,
          weather: weather,
          environment_type: environment,
          image_url: '/planets/11test.png',
          prompt: prompt
        )

        created_tiles << tile
      end
    end

    # Phase 2: Attempt image generation if not skipped
    return if skip_image_generation

    begin
      Timeout.timeout(12) do
        created_tiles.each do |tile|
          prompt = tile.prompt
          service = OpenaiService.new(prompt: prompt, type: 'image')
          response = service.call

          if response.is_a?(Hash)
            new_url = response.dig("data", 0, "url") || '/planets/11test.png'
            tile.update!(image_url: new_url)
          end
        end
      end
    rescue Timeout::Error
      # If timed out, tiles remain with their placeholder image_url
      Rails.logger.error "Image generation timed out after 12 seconds. Tiles left with placeholder images."
    end
  end

  def initialize_grid_unless_seeding
    initialize_grid(skip_image_generation: seeding?)
  end

  # Method to detect if the code is running during seeding
  def seeding?
    caller.any? { |line| line.include?('db/seeds.rb') }
  end
end
