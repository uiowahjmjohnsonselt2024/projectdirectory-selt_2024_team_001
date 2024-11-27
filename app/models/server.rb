class Server < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :grid_tiles, dependent: :destroy

  after_create :initialize_grid

  private

  def initialize_grid
    (1..6).each do |row|
      (1..6).each do |col|
        grid_tiles.create!(
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
