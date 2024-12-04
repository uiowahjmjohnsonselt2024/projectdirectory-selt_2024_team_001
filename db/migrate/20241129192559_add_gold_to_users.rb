class AddGoldToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :gold, :integer, default: 1000, null: false
  end
end
