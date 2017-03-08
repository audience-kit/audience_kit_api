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

ActiveRecord::Schema.define(version: 20170307174742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "pg_stat_statements"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "device_type"
    t.string   "vendor_identifier"
    t.macaddr  "bluetooth_address"
    t.macaddr  "wifi_address"
    t.string   "model"
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
    t.uuid     "person_id"
    t.boolean  "featured"
    t.string   "name_override"
    t.index ["facebook_id"], name: "index_events_on_facebook_id", using: :btree
    t.index ["person_id"], name: "index_events_on_person_id", using: :btree
    t.index ["venue_id"], name: "index_events_on_venue_id", using: :btree
  end

  create_table "friendships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid    "friend_high_id"
    t.uuid    "friend_low_id"
    t.date    "friends_at"
    t.string  "friend_hash"
    t.integer "weight"
    t.index ["friend_high_id"], name: "index_friendships_on_friend_high_id", using: :btree
    t.index ["friend_low_id"], name: "index_friendships_on_friend_low_id", using: :btree
  end

  create_table "locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                                 null: false
    t.datetime  "updated_at",                                                                 null: false
    t.string    "label"
    t.string    "name"
    t.geography "location",          limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "google_place_id"
    t.datetime  "google_updated_at"
    t.jsonb     "google_location"
    t.integer   "beacon_major"
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.bigint   "facebook_id",                         null: false
    t.jsonb    "facebook_graph"
    t.datetime "facebook_updated_at"
    t.string   "name"
    t.string   "facebook_token"
    t.boolean  "requires_like",       default: false
    t.uuid     "locale_id"
    t.uuid     "venue_id"
    t.string   "instagram"
    t.string   "sound_cloud"
    t.string   "twitter"
    t.boolean  "featured"
    t.string   "name_override"
  end

  create_table "person_locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "person_id"
    t.integer "locale_id"
    t.index ["locale_id"], name: "index_person_locales_on_locale_id", using: :btree
    t.index ["person_id"], name: "index_person_locales_on_person_id", using: :btree
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                               null: false
    t.datetime  "updated_at",                                                               null: false
    t.uuid      "token_id"
    t.string    "session_token"
    t.uuid      "device_id"
    t.uuid      "user_id"
    t.inet      "origin_ip"
    t.geography "geo_ip_location", limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "version"
    t.integer   "build"
    t.index ["device_id"], name: "index_sessions_on_device_id", using: :btree
    t.index ["token_id"], name: "index_sessions_on_token_id", using: :btree
    t.index ["user_id"], name: "index_sessions_on_user_id", using: :btree
  end

  create_table "user_locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                            null: false
    t.datetime  "updated_at",                                                            null: false
    t.uuid      "user_id",                                                               null: false
    t.geography "location",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer   "beacon_minor"
    t.uuid      "locale_id"
    t.uuid      "venue_id"
    t.index ["locale_id"], name: "index_user_locations_on_locales_id", using: :btree
    t.index ["user_id"], name: "index_user_locations_on_users_id", using: :btree
    t.index ["venue_id"], name: "index_user_locations_on_venues_id", using: :btree
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
    t.jsonb    "facebook_graph"
    t.index ["email_address"], name: "index_users_on_email_address", using: :btree
    t.index ["facebook_id"], name: "index_users_on_facebook_id", using: :btree
  end

  create_table "venue_beacons", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "venue_id"
    t.integer "beacon_id"
    t.index ["venue_id"], name: "index_venue_beacons_on_venue_id", using: :btree
  end

  create_table "venue_mapping", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "venue_id"
    t.bigint  "facebook_id"
    t.index ["venue_id"], name: "index_venue_mapping_on_venue_id", using: :btree
  end

  create_table "venues", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                                                   null: false
    t.datetime  "updated_at",                                                                                   null: false
    t.string    "name"
    t.bigint    "facebook_id"
    t.uuid      "locale_id"
    t.datetime  "facebook_updated_at"
    t.string    "label"
    t.string    "country"
    t.string    "state"
    t.string    "zip"
    t.string    "street"
    t.string    "phone"
    t.string    "google_place_id"
    t.datetime  "google_updated_at"
    t.jsonb     "facebook_graph"
    t.geography "location",            limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.jsonb     "google_location"
    t.bigint    "beacon_id"
    t.boolean   "hidden",                                                                       default: false
    t.boolean   "featured"
    t.string    "name_override"
    t.index ["facebook_id"], name: "index_venues_on_facebook_id", unique: true, using: :btree
    t.index ["google_place_id"], name: "index_venues_on_google_place_id", using: :btree
    t.index ["locale_id"], name: "index_venues_on_locale_id", using: :btree
  end

  add_foreign_key "events", "venues"
  add_foreign_key "friendships", "users", column: "friend_high_id"
  add_foreign_key "friendships", "users", column: "friend_low_id"
  add_foreign_key "sessions", "devices"
  add_foreign_key "sessions", "users"
  add_foreign_key "venues", "locales"
end
