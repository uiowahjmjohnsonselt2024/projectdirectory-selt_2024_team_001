class PlayerItem < ApplicationRecord
  belongs_to :player
  belongs_to :store_item

  # Allow quantity to be zero or greater
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end