class Server < ApplicationRecord
  has_many :user_servers, dependent: :destroy
  has_many :users, through: :user_servers
  has_many :grid_tiles, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :players

  after_create :initialize_grid

  private

  def player_for_user(user)
    players.find_by(user: user)
  end

  # Initialize a 6x6 grid of tiles for the server
  def initialize_grid
    (0..5).each do |row|
      (0..5).each do |col|
        grid_tiles.create!(
          row: row,
          column: col,
          weather: 'temp',
          environment_type: 'temp',
          image_url: "default_image.jpg"
        )
      end
    end
  end
end
