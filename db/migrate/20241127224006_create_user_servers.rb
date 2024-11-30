class CreateUserServers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_servers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true
      t.datetime :registered_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    # Add a unique index to prevent duplicate registrations
    add_index :user_servers, [:user_id, :server_id], unique: true
  end
end
