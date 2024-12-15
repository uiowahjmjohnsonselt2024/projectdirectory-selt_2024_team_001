class CreatePlayerItems < ActiveRecord::Migration[7.2]
  def change
    create_table :player_items do |t|
      t.references :player, null: false, foreign_key: true
      t.references :store_item, null: false, foreign_key: true
      t.integer :quantity, default: 0, null: false

      t.timestamps
    end
  end
end
