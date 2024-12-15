class Player < ApplicationRecord
  belongs_to :user
  belongs_to :server
  has_many :player_items
  has_many :store_items, through: :player_items
  validates :row, :column, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Move the player to a new position
  def move_to(target_row, target_column, user)
    # Validate if the target tile exists in the grid
    unless server.grid_tiles.exists?(row: target_row, column: target_column)
      errors.add(:base, "Invalid target position. The tile does not exist.")
      return false
    end

    # Calculate movement cost
    distance = (self.row - target_row).abs + (self.column - target_column).abs
    cost = distance > 1 ? 1 : 0

    # Ensure the user has enough shards for non-adjacent moves
    if cost > 0 && user.shards < cost
      errors.add(:base, "Insufficient shards for movement.")
      return false
    end

    # Perform the movement transaction
    Player.transaction do
      user.decrement!(:shards, cost) if cost > 0
      self.update!(row: target_row, column: target_column)
    if self.user == user
      update(row: target_row, column: target_column)
    else
      errors.add(:base, "You can only move your own player.")
      false
    end
      true
    rescue StandardError => e
      errors.add(:base, e.message)
      false
  end
  end
  end
