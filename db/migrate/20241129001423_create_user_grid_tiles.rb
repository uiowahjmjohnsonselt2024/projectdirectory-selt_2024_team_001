class CreateUserGridTiles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_grid_tiles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :grid_tile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
