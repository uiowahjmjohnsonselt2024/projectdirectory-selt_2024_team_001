# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_24_220035) do
  create_table "grid_cells", force: :cascade do |t|
    t.integer "server_id", null: false
    t.integer "row", null: false
    t.integer "column", null: false
    t.string "weather", null: false
    t.string "environment_type", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id", "row", "column"], name: "index_grid_cells_on_server_id_and_row_and_column", unique: true
    t.index ["server_id"], name: "index_grid_cells_on_server_id"
  end

  create_table "servers", force: :cascade do |t|
    t.integer "server_num"
    t.string "status"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.integer "shards"
    t.float "money"
  end

  add_foreign_key "grid_cells", "servers"
end
