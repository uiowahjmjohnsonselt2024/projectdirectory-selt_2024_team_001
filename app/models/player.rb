class Player < ApplicationRecord
  belongs_to :user
  belongs_to :server
  has_many :player_items
  has_many :store_items, through: :player_items

  def move_to(target_row, target_column, user)
    if self.user == user
      update(row: target_row, column: target_column)
    else
      errors.add(:base, "You can only move your own player.")
      false
    end
  end
end
