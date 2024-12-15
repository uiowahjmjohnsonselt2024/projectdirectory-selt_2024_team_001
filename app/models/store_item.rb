# app/models/store_item.rb
class StoreItem < ApplicationRecord
  # Remove belongs_to :user since store items are not user-specific
  # If you need to associate items with a creator/admin, add a different relation explicitly
  validates :title, :description, :cost, :currency, presence: true

  # Association with PlayerItem
  has_many :player_items
  has_many :players, through: :player_items
end
