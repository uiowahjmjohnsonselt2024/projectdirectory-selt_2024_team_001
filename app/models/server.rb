class Server < ApplicationRecord
  has_many :grid_tiles, dependent: :destroy
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  after_create :initialize_grid

  private

  def initialize_grid
    (0..5).each do |row|
      (0..5).each do |column|
        self.grid_tiles.create!(
          row: row,
          column: column,
          environment: ["forest", "desert", "ocean"].sample,
          time_of_day: ["morning", "afternoon", "night"].sample,
          weather: ["sunny", "rainy", "snowy"].sample
        )
      end
    end
  end
end
