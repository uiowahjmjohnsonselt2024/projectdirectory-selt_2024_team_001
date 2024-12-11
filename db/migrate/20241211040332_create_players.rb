class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true

      t.timestamps
    end

    add_index :players, [:user_id, :server_id], unique: true
  end
end
