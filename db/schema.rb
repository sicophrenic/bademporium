# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131210224248) do

  create_table "blackjacks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.string   "value",      null: false
    t.string   "suit",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deploy_services", force: true do |t|
    t.string   "name",                                 null: false
    t.boolean  "enabled_for_beta",     default: false
    t.boolean  "enabled_for_everyone", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_hands", force: true do |t|
    t.string   "game_type",      null: false
    t.string   "hand_ids",       null: false
    t.integer  "dealer_hand_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_hands", ["game_type"], name: "index_game_hands_on_game_type"

  create_table "games", force: true do |t|
    t.string   "type"
    t.integer  "num_players",                             null: false
    t.integer  "current_player_idx", default: 0
    t.integer  "num_decks"
    t.boolean  "should_save_hands",  default: false
    t.string   "cards",              default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hands", force: true do |t|
    t.integer  "player_id"
    t.integer  "dealer_id"
    t.string   "cards",      default: "--- []\n"
    t.boolean  "played",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.integer  "user_id",                          null: false
    t.integer  "game_id",                          null: false
    t.integer  "current_hand_idx", default: 0,     null: false
    t.boolean  "deal_in",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "beta",                   default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
