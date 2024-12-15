class AddPromptToGridTiles < ActiveRecord::Migration[7.2]
  def change
    add_column :grid_tiles, :prompt, :string
  end
end
