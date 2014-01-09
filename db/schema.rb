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

ActiveRecord::Schema.define(version: 20140108143301) do

  create_table "contests", force: true do |t|
    t.integer  "user_id"
    t.integer  "referee_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deadline"
    t.datetime "start"
    t.string   "name"
    t.string   "contest_type"
  end

  add_index "contests", ["referee_id"], name: "index_contests_on_referee_id"
  add_index "contests", ["user_id"], name: "index_contests_on_user_id"

  create_table "match_types", force: true do |t|
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", force: true do |t|
    t.integer  "manager_id"
    t.datetime "completion"
    t.integer  "match_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "earliest_start"
    t.string   "manager_type"
  end

  add_index "matches", ["manager_id", "manager_type"], name: "index_matches_on_manager_id_and_manager_type"
  add_index "matches", ["manager_id"], name: "index_matches_on_manager_id"
  add_index "matches", ["match_type_id"], name: "index_matches_on_match_type_id"

  create_table "player_matches", force: true do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "result"
  end

  add_index "player_matches", ["match_id"], name: "index_player_matches_on_match_id"
  add_index "player_matches", ["player_id"], name: "index_player_matches_on_player_id"

  create_table "players", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.integer  "programming_language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "name"
    t.boolean  "downloadable",            default: false
    t.boolean  "playable",                default: true
    t.string   "file_location"
  end

  create_table "programming_languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referees", force: true do |t|
    t.string   "file_location"
    t.integer  "programming_language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "rules_url"
    t.integer  "players_per_game"
    t.integer  "user_id"
  end

  add_index "referees", ["programming_language_id"], name: "index_referees_on_programming_language_id"
  add_index "referees", ["user_id"], name: "index_referees_on_user_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.boolean  "contest_creator", default: false
    t.boolean  "banned",          default: false
    t.string   "chat_url"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end