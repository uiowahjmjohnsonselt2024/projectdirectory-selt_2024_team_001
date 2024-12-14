class Server < ApplicationRecord
  has_many :user_servers, dependent: :destroy
  has_many :users, through: :user_servers
  has_many :grid_tiles, dependent: :destroy
  has_many :players

  after_create :initialize_grid

  private

  def player_for_user(user)
    players.find_by(user: user)
  end

  # Initialize a 6x6 grid of tiles for the server
  def initialize_grid
    possible_weathers = %w[clear_atmosphere partially_cloudy fully_cloudy stormy hurricane_scarred foggy_atmosphere frozen_atmosphere volcanic_clouds auroral_activity dust_storms]
    possible_environments = %w[terrestrial desert ocean frozen lava gas_giant crystal metallic jungle ruined]
    (1..6).each do |row|
      (1..6).each do |col|
        weather = possible_weathers.sample # Chooses a random element from the weather list
        environment = possible_environments.sample

        prompt = "A sci-fi landscape with #{weather} weather in a #{environment_type} environment that is viewed from space."
        service = OpenaiService.new(prompt: prompt, type:'image')
        image_url = service.call || "default_image.jpg"

        grid_tiles.create!(
          row: row,
          column: col,
          weather: weather,
          environment_type: environment,
          image_url: image_url
        )
      end
    end
  end
end

