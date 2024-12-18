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

ActiveRecord::Schema[7.2].define(version: 2024_12_15_121024) do
  create_table "achievements", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "unlocked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "grid_tiles", force: :cascade do |t|
    t.integer "server_id", null: false
    t.integer "row", null: false
    t.integer "column", null: false
    t.string "weather", null: false
    t.string "environment_type", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prompt"
    t.index ["server_id", "row", "column"], name: "index_grid_tiles_on_server_id_and_row_and_column", unique: true
    t.index ["server_id"], name: "index_grid_tiles_on_server_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "server_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_messages_on_server_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "player_items", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "store_item_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_player_items_on_player_id"
    t.index ["store_item_id"], name: "index_player_items_on_store_item_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "server_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "row", default: 0, null: false
    t.integer "column", default: 0, null: false
    t.integer "gold", default: 0, null: false
    t.index ["server_id"], name: "index_players_on_server_id"
    t.index ["user_id", "server_id"], name: "index_players_on_user_id_and_server_id", unique: true
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "servers", force: :cascade do |t|
    t.integer "server_num"
    t.string "status"
  end

  create_table "store_items", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "cost", null: false
    t.string "category"
    t.string "modifier"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_grid_tiles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "grid_tile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grid_tile_id"], name: "index_user_grid_tiles_on_grid_tile_id"
    t.index ["user_id"], name: "index_user_grid_tiles_on_user_id"
  end

  create_table "user_servers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "server_id", null: false
    t.datetime "registered_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_user_servers_on_server_id"
    t.index ["user_id", "server_id"], name: "index_user_servers_on_user_id_and_server_id", unique: true
    t.index ["user_id"], name: "index_user_servers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "shards", default: 0
    t.float "money", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gold", default: 1000, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "achievements", "users"
  add_foreign_key "messages", "servers"
  add_foreign_key "messages", "users"
  add_foreign_key "player_items", "players"
  add_foreign_key "player_items", "store_items"
  add_foreign_key "players", "servers"
  add_foreign_key "players", "users"
  add_foreign_key "user_grid_tiles", "grid_tiles"
  add_foreign_key "user_grid_tiles", "users"
  add_foreign_key "user_servers", "servers"
  add_foreign_key "user_servers", "users"
end
