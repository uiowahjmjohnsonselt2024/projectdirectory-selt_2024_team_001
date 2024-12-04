class GridTile < ApplicationRecord
  belongs_to :server
  has_many :user_grid_tiles
  has_many :users, through: :user_grid_tiles

  validates :row, :column, presence: true
  validates :weather, :environment_type, presence: true
  validates :server_id, uniqueness: { scope: [:row, :column], message: "A tile already exists for this row and column on this server" }

  # Scope for finding tiles in a specific server
  scope :for_server, ->(server_id) { where(server_id: server_id) }

  # Check if a tile is occupied
  def occupied?
    users.exists?
  end

  # Get the list of users on this tile
  def occupying_users
    users
  end
end
