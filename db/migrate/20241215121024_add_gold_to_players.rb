class AddGoldToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :gold, :integer
  end
end
