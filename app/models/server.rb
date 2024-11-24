class Server < ApplicationRecord
  has_many :user_servers, dependent: :destroy
  has_many :users, through: :user_servers
  has_many :grid_cells, dependent: :destroy

  after_create :initialize_grid

  private

  def initialize_grid
    (1..6).each do |row|
      (1..6).each do |col|
        grid_cells.create!(
          row: row,
          column: col,
          weather: "Clear",
          environment_type: "Forest",
          image_url: "default_image.jpg"
        )
      end
    end
  end
end
