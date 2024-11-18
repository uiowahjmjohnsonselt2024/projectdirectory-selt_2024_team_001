class GridTile < ApplicationRecord
  belongs_to :server
  has_many :users

  validates :row, :column, presence: true, numericality: { only_integer: true }
  validates :environment, :time_of_day, :weather, presence: true
end
