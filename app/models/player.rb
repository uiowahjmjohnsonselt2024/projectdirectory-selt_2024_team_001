class Player < ApplicationRecord
  belongs_to :user
  belongs_to :server

  validates :row, :column, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Example method to update position
  def update_position(new_row, new_column)
    update!(row: new_row, column: new_column)
  end
end
