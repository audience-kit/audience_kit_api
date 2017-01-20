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

ActiveRecord::Schema.define(version: 20170118032138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "postgis"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "device_type"
    t.string   "vendor_identifier"
    t.macaddr  "bluetooth_address"
    t.macaddr  "wifi_address"
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.uuid     "venue_id"
    t.jsonb    "facebook_graph"
    t.bigint   "facebook_id"
    t.index ["facebook_id"], name: "index_events_on_facebook_id", using: :btree
    t.index ["venue_id"], name: "index_events_on_venue_id", using: :btree
  end

# Could not dump table "locales" because of following StandardError
#   Unknown type 'geography' for column 'location'

# Could not dump table "sessions" because of following StandardError
#   Unknown type 'geography' for column 'geo_ip_location'

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
    t.jsonb    "facebook_graph"
    t.index ["email_address"], name: "index_users_on_email_address", using: :btree
    t.index ["facebook_id"], name: "index_users_on_facebook_id", using: :btree
  end

# Could not dump table "venues" because of following StandardError
#   Unknown type 'geography' for column 'location'

  add_foreign_key "events", "venues"
  add_foreign_key "sessions", "devices"
  add_foreign_key "sessions", "users"
  add_foreign_key "venues", "locales"
end
