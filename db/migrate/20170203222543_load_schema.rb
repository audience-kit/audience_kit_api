class LoadSchema < ActiveRecord::Migration[5.0]
  def change

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

    create_table "locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.datetime  "created_at",                                              null: false
      t.datetime  "updated_at",                                              null: false
      t.string    "label"
      t.string    "name"
      t.geography "location",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
      t.string    "google_place_id"
      t.datetime  "google_updated_at"
      t.jsonb     "google_location"
      t.integer   "beacon_major"
    end

    create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.datetime  "created_at",                                            null: false
      t.datetime  "updated_at",                                            null: false
      t.uuid      "token_id"
      t.string    "session_token"
      t.uuid      "device_id"
      t.uuid      "user_id"
      t.inet      "origin_ip"
      t.geography "geo_ip_location",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
      t.index ["device_id"], name: "index_sessions_on_device_id", using: :btree
      t.index ["token_id"], name: "index_sessions_on_token_id", using: :btree
      t.index ["user_id"], name: "index_sessions_on_user_id", using: :btree
    end

    create_table "user_locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.uuid     "user_id",      null: false
      t.geography "location",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
      t.integer  "beacon_minor"
      t.uuid     "locale_id"
      t.uuid     "venue_id"
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

    create_table "venues", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
      t.datetime  "created_at",                                                                null: false
      t.datetime  "updated_at",                                                                null: false
      t.string    "name"
      t.bigint    "facebook_id"
      t.uuid      "locale_id"
      t.datetime  "facebook_updated_at"
      t.string    "label"
      t.boolean   "is_hidden",                                                 default: false
      t.string    "country"
      t.string    "state"
      t.string    "zip"
      t.string    "street"
      t.string    "phone"
      t.string    "google_place_id"
      t.datetime  "google_updated_at"
      t.jsonb     "facebook_graph"
      t.geography "location",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
      t.jsonb     "google_location"
      t.bigint    "beacon_id"
      t.index ["facebook_id"], name: "index_venues_on_facebook_id", using: :btree
      t.index ["google_place_id"], name: "index_venues_on_google_place_id", using: :btree
      t.index ["locale_id"], name: "index_venues_on_locale_id", using: :btree
    end

    add_foreign_key "events", "venues"
    add_foreign_key "sessions", "devices"
    add_foreign_key "sessions", "users"
    add_foreign_key "venues", "locales"
  end
end
