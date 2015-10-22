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

ActiveRecord::Schema.define(version: 20151022185020) do

  create_table "faqs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.text     "bio",        limit: 65535
    t.text     "skills",     limit: 65535
    t.text     "schools",    limit: 65535
    t.text     "companies",  limit: 65535
    t.text     "music",      limit: 65535
    t.text     "movies",     limit: 65535
    t.text     "television", limit: 65535
    t.text     "magazines",  limit: 65535
    t.text     "books",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "specs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                null: false
    t.string   "first_name", limit: 255, default: ""
    t.string   "last_name",  limit: 255, default: ""
    t.string   "occupation", limit: 255, default: ""
    t.string   "city",       limit: 255, default: ""
    t.string   "state",      limit: 255, default: ""
    t.string   "zip_code",   limit: 255, default: ""
    t.string   "gender",     limit: 255
    t.date     "birthdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "screen_name",         limit: 255
    t.string   "email",               limit: 255
    t.string   "password",            limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "authorization_token", limit: 255
  end

end
