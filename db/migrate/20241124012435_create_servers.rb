class CreateServers < ActiveRecord::Migration[7.2]
  def change
    create_table :servers do |t|
      t.integer :server_num
      t.string :status

    end
  end
end
