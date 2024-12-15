class CreateStoreItems < ActiveRecord::Migration[7.2]
  def change
    create_table :store_items do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :cost, null: false
      t.string :category
      t.string :modifier
      t.string :currency

      t.timestamps
    end
  end
end
