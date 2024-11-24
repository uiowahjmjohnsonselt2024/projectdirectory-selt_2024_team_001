class CreateGridCells < ActiveRecord::Migration[7.2]
  def change
    create_table :grid_cells do |t|
      t.references :server, null: false, foreign_key: true
      t.integer :row, null: false
      t.integer :column, null: false
      t.string :weather, null: false
      t.string :environment_type, null: false
      t.string :image_url

      t.timestamps
    end

    add_index :grid_cells, [:server_id, :row, :column], unique: true
  end
end
