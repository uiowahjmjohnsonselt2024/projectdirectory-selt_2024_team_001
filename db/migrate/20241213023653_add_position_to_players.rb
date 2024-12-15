class AddPositionToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :row, :integer, null: false, default: 0
    add_column :players, :column, :integer, null: false, default: 0
  end
end
