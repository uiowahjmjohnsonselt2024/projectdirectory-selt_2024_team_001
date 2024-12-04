class CreateGridTiles < ActiveRecord::Migration[7.2]
  def change
    create_table :grid_tiles do |t|
      t.integer :server_id, null: false
      t.integer :row, null: false
      t.integer :column, null: false
      t.string :weather, null: false
      t.string :environment_type, null: false
      t.string :image_url
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:server_id, :row, :column], name: "index_grid_tiles_on_server_id_and_row_and_column", unique: true
      t.index :server_id, name: "index_grid_tiles_on_server_id"
    end
  end
end
