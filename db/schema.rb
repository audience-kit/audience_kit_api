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

ActiveRecord::Schema.define(version: 20170312143842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "device_type"
    t.string   "vendor_identifier"
    t.macaddr  "bluetooth_address"
    t.macaddr  "wifi_address"
    t.string   "model"
    t.index ["device_type", "vendor_identifier"], name: "devices_by_vendor", unique: true, using: :btree
  end

  create_table "event_people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid     "person_id",  null: false
    t.uuid     "event_id",   null: false
    t.string   "role",       null: false
    t.index ["event_id"], name: "index_event_people_on_event_id", using: :btree
    t.index ["person_id"], name: "index_event_people_on_person_id", using: :btree
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.uuid     "venue_id",                      null: false
    t.jsonb    "facebook_graph"
    t.bigint   "facebook_id"
    t.string   "name_override"
    t.integer  "order",          default: 1000
    t.index ["facebook_id"], name: "index_events_on_facebook_id", using: :btree
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
    t.datetime  "created_at",                                                              null: false
    t.datetime  "updated_at",                                                              null: false
    t.string    "label"
    t.string    "name"
    t.integer   "beacon_major"
    t.geography "envelope",     limit: {:srid=>4326, :type=>"polygon", :geographic=>true}
    t.uuid      "location_id",                                                             null: false
  end

  create_table "location_beacons", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid    "location_id",  null: false
    t.integer "beacon_minor", null: false
    t.index ["location_id"], name: "index_location_beacons_on_location_id", using: :btree
  end

  create_table "locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                               null: false
    t.datetime  "updated_at",                                                               null: false
    t.string    "google_place_id",                                                          null: false
    t.jsonb     "google_location",                                                          null: false
    t.geography "location",        limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
    t.uuid      "locale_id",                                                                null: false
    t.index ["google_place_id"], name: "index_locations_on_google_place_id", unique: true, using: :btree
    t.index ["locale_id"], name: "index_locations_on_locale_id", using: :btree
  end

  create_table "pages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name",                  null: false
    t.string   "name_override"
    t.bigint   "facebook_id",           null: false
    t.jsonb    "facebook_graph",        null: false
    t.string   "facebook_access_token"
    t.string   "facets",                             array: true
    t.index ["facebook_id"], name: "index_pages_on_facebook_id", unique: true, using: :btree
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid    "page_id",                       null: false
    t.integer "order",         default: 1000,  null: false
    t.boolean "global",        default: false, null: false
    t.boolean "like_required", default: false, null: false
    t.uuid    "photo_id"
    t.index ["page_id"], name: "index_people_on_page_id", unique: true, using: :btree
    t.index ["photo_id"], name: "index_people_on_photo_id", using: :btree
  end

  create_table "person_locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "locale_id", null: false
    t.index ["locale_id"], name: "index_person_locales_on_locale_id", using: :btree
    t.index ["person_id", "locale_id"], name: "person_locale_unique_key", unique: true, using: :btree
    t.index ["person_id"], name: "index_person_locales_on_person_id", using: :btree
  end

  create_table "photos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "source_url", null: false
    t.string   "hash",       null: false
    t.binary   "content",    null: false
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                             null: false
    t.datetime  "updated_at",                                                             null: false
    t.uuid      "token_id"
    t.string    "session_token"
    t.uuid      "device_id"
    t.uuid      "user_id"
    t.inet      "origin_ip"
    t.geography "location",      limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "version"
    t.integer   "build"
    t.index ["device_id"], name: "index_sessions_on_device_id", using: :btree
    t.index ["token_id"], name: "index_sessions_on_token_id", using: :btree
    t.index ["user_id"], name: "index_sessions_on_user_id", using: :btree
  end

  create_table "social_links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.uuid     "object_id",                  null: false
    t.string   "provider",                   null: false
    t.string   "handle",                     null: false
    t.boolean  "primary",    default: false, null: false
  end

  create_table "social_updates", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.uuid     "social_link_id", null: false
    t.string   "body",           null: false
    t.index ["social_link_id"], name: "index_social_updates_on_social_link_id", using: :btree
  end

  create_table "tracks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.uuid     "social_link_id",      null: false
    t.string   "title",               null: false
    t.string   "provider_url",        null: false
    t.string   "provider_identifier", null: false
    t.index ["social_link_id"], name: "index_tracks_on_social_link_id", using: :btree
  end

  create_table "user_locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime  "created_at",                                                           null: false
    t.datetime  "updated_at",                                                           null: false
    t.geography "point",       limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.uuid      "venue_id"
    t.uuid      "session_id",                                                           null: false
    t.uuid      "location_id",                                                          null: false
    t.boolean   "beacon"
    t.index ["location_id"], name: "index_user_locations_on_location_id", using: :btree
    t.index ["session_id"], name: "index_user_locations_on_session_id", using: :btree
    t.index ["venue_id"], name: "index_user_locations_on_venues_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name"
    t.string   "email_address"
    t.bigint   "facebook_id",              null: false
    t.string   "facebook_token"
    t.datetime "facebook_token_issued_at"
    t.string   "profile_image_url"
    t.string   "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "culture"
    t.jsonb    "facebook_graph"
    t.index ["email_address"], name: "index_users_on_email_address", using: :btree
    t.index ["facebook_id"], name: "users_facebook_id_uindex", unique: true, using: :btree
  end

  create_table "venue_pages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.uuid     "venue_id",                  null: false
    t.uuid     "page_id",                   null: false
    t.integer  "order",      default: 1000, null: false
    t.index ["page_id", "venue_id", "order"], name: "venue_pages_unique_key", unique: true, using: :btree
    t.index ["page_id"], name: "index_venue_pages_on_page_id", using: :btree
    t.index ["page_id"], name: "venue_pages_by_page_id", using: :btree
    t.index ["venue_id"], name: "index_venue_pages_on_venue_id", using: :btree
    t.index ["venue_id"], name: "venue_pages_by_venue_id", using: :btree
  end

  create_table "venues", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid      "locale_id"
    t.boolean   "hidden",                                                                        default: false
    t.integer   "order",                                                                         default: 1000
    t.integer   "distance_tolerance"
    t.geography "envelope",           limit: {:srid=>4326, :type=>"polygon", :geographic=>true}
    t.uuid      "location_id"
    t.uuid      "photo_id"
    t.uuid      "hero_banner_id"
    t.index ["locale_id"], name: "index_venues_on_locale_id", using: :btree
    t.index ["photo_id"], name: "index_venues_on_photo_id", using: :btree
  end

  add_foreign_key "events", "venues"
  add_foreign_key "friendships", "users", column: "friend_high_id"
  add_foreign_key "friendships", "users", column: "friend_low_id"
  add_foreign_key "sessions", "devices"
  add_foreign_key "sessions", "users"
  add_foreign_key "venues", "locales"
  add_foreign_key "venues", "photos", column: "hero_banner_id"
end
