class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.references :user, null: false, foreign_key: true # Links to users table
      t.string :name, null: false                        # Achievement name
      t.text :description                                # Achievement description
      t.datetime :unlocked_at                            # Timestamp for when it was unlocked

      t.timestamps
    end
  end
end
