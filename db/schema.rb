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

ActiveRecord::Schema.define(version: 20170110175241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "device_type"
    t.string   "vendor_identifier"
  end

  create_table "locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "label"
    t.string   "name"
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.uuid     "token_id"
    t.uuid     "device_id"
    t.uuid     "user_id"
    t.string   "session_token", limit: 64
    t.index ["device_id"], name: "index_sessions_on_device_id", using: :btree
    t.index ["token_id"], name: "index_sessions_on_token_id", using: :btree
    t.index ["user_id"], name: "index_sessions_on_user_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name"
    t.string   "email_address"
    t.bigint   "facebook_id"
    t.string   "facebook_token"
    t.datetime "facebook_token_issued_at"
    t.string   "profile_image_url"
    t.string   "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "culture"
  end

  create_table "venues", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.bigint   "facebook_id"
    t.uuid     "locale_id"
    t.index ["locale_id"], name: "index_venues_on_locale_id", using: :btree
  end

  add_foreign_key "sessions", "devices"
  add_foreign_key "sessions", "users"
  add_foreign_key "venues", "locales"
end
