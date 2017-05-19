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

ActiveRecord::Schema.define(version: 20170519183136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key", null: false
  end

  create_table "devices", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "device_type"
    t.string "vendor_identifier"
    t.macaddr "bluetooth_address"
    t.macaddr "wifi_address"
    t.string "model"
    t.index ["device_type", "vendor_identifier"], name: "devices_by_vendor", unique: true
  end

  create_table "event_people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "person_id", null: false
    t.uuid "event_id", null: false
    t.string "role", null: false
    t.index ["event_id"], name: "index_event_people_on_event_id"
    t.index ["person_id"], name: "index_event_people_on_person_id"
  end

  create_table "events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.uuid "venue_id", null: false
    t.jsonb "facebook_graph"
    t.bigint "facebook_id"
    t.string "name_override"
    t.integer "order", default: 1000, null: false
    t.uuid "cover_photo_id"
    t.boolean "is_featured", default: false, null: false
    t.index ["cover_photo_id"], name: "index_events_on_cover_photo_id"
    t.index ["facebook_id"], name: "index_events_on_facebook_id"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "friendships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "friend_high_id"
    t.uuid "friend_low_id"
    t.date "friends_at"
    t.string "friend_hash"
    t.integer "weight"
    t.index ["friend_high_id"], name: "index_friendships_on_friend_high_id"
    t.index ["friend_low_id"], name: "index_friendships_on_friend_low_id"
  end

  create_table "locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.string "name"
    t.integer "beacon_major"
    t.geography "envelope", limit: {:srid=>4326, :type=>"st_polygon", :geographic=>true}
    t.uuid "location_id"
    t.integer "timezone_zulu_delta"
  end

  create_table "location_beacons", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "location_id", null: false
    t.integer "beacon_minor", null: false
    t.index ["location_id"], name: "index_location_beacons_on_location_id"
  end

  create_table "locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_place_id", null: false
    t.jsonb "google_location", null: false
    t.geography "point", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.uuid "photo_id"
    t.geography "envelope", limit: {:srid=>4326, :type=>"st_polygon", :geographic=>true}
    t.index ["google_place_id"], name: "index_locations_on_google_place_id", unique: true
  end

  create_table "pages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "name_override"
    t.bigint "facebook_id", null: false
    t.jsonb "facebook_graph", null: false
    t.string "facebook_access_token"
    t.string "facets", array: true
    t.boolean "requires_user_token", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.uuid "photo_id", null: false
    t.uuid "cover_photo_id"
    t.index ["facebook_id"], name: "index_pages_on_facebook_id", unique: true
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "page_id", null: false
    t.integer "order", default: 1000, null: false
    t.boolean "global", default: false, null: false
    t.boolean "like_required", default: false, null: false
    t.index ["page_id"], name: "index_people_on_page_id", unique: true
  end

  create_table "person_locales", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "locale_id", null: false
    t.index ["locale_id"], name: "index_person_locales_on_locale_id"
    t.index ["person_id", "locale_id"], name: "person_locale_unique_key", unique: true
    t.index ["person_id"], name: "index_person_locales_on_person_id"
  end

  create_table "photos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_url", null: false
    t.binary "content_hash", null: false
    t.string "mime", null: false
    t.string "cdn_url", null: false
    t.index ["content_hash"], name: "photos_hash_uindex", unique: true
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "token_id"
    t.string "session_token"
    t.uuid "device_id"
    t.uuid "user_id"
    t.inet "origin_ip"
    t.geography "location", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "version"
    t.integer "build"
    t.index ["device_id"], name: "index_sessions_on_device_id"
    t.index ["token_id"], name: "index_sessions_on_token_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "social_links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "object_id", null: false
    t.string "provider", null: false
    t.string "handle", null: false
    t.boolean "primary", default: false, null: false
  end

  create_table "social_updates", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "social_link_id", null: false
    t.string "body", null: false
    t.index ["social_link_id"], name: "index_social_updates_on_social_link_id"
  end

  create_table "ticket_types", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "event_id", null: false
    t.decimal "price"
    t.boolean "available", default: true, null: false
    t.string "provider", null: false
    t.string "provider_id", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "tracks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "social_link_id", null: false
    t.string "title", null: false
    t.string "provider_url", null: false
    t.string "provider_identifier", null: false
    t.string "download_url"
    t.string "stream_url"
    t.jsonb "metadata"
    t.uuid "photo_id"
    t.uuid "waveform_photo_id"
    t.index ["social_link_id"], name: "index_tracks_on_social_link_id"
  end

  create_table "user_likes", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "page_id", null: false
    t.index ["page_id"], name: "index_user_likes_on_page_id"
    t.index ["user_id"], name: "index_user_likes_on_user_id"
  end

  create_table "user_locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.geography "point", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.uuid "venue_id"
    t.uuid "session_id", null: false
    t.uuid "location_id", null: false
    t.boolean "beacon", default: false, null: false
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["session_id"], name: "index_user_locations_on_session_id"
    t.index ["venue_id"], name: "index_user_locations_on_venues_id"
  end

  create_table "user_rsvps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "user_id", null: false
    t.uuid "event_id", null: false
    t.string "state", null: false
    t.index ["event_id"], name: "user_rsvps_event_id_index"
    t.index ["user_id", "event_id"], name: "user_rsvps_user_id_event_id_uindex", unique: true
    t.index ["user_id"], name: "user_rsvps_user_id_index"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email_address", null: false
    t.bigint "facebook_id", null: false
    t.string "facebook_token"
    t.datetime "facebook_token_issued_at"
    t.string "gender"
    t.string "first_name"
    t.string "last_name"
    t.string "culture"
    t.jsonb "facebook_graph"
    t.string "facebook_scopes", array: true
    t.uuid "photo_id"
    t.index ["email_address"], name: "index_users_on_email_address"
    t.index ["facebook_id"], name: "users_facebook_id_uindex", unique: true
  end

  create_table "venue_messages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "venue_id"
    t.uuid "user_id"
    t.string "message"
    t.index ["user_id"], name: "index_venue_messages_on_user_id"
    t.index ["venue_id"], name: "index_venue_messages_on_venue_id"
  end

  create_table "venues", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "locale_id"
    t.boolean "hidden", default: false, null: false
    t.integer "order", default: 1000, null: false
    t.integer "distance_tolerance", default: 250, null: false
    t.uuid "location_id"
    t.uuid "page_id", null: false
    t.index ["locale_id"], name: "index_venues_on_locale_id"
    t.index ["page_id"], name: "index_venues_on_page_id"
  end

  add_foreign_key "events", "photos", column: "cover_photo_id"
  add_foreign_key "events", "venues"
  add_foreign_key "friendships", "users", column: "friend_high_id"
  add_foreign_key "friendships", "users", column: "friend_low_id"
  add_foreign_key "locations", "photos", name: "locations_photos_id_fk"
  add_foreign_key "pages", "photos", column: "cover_photo_id", name: "pages_photos_cover_id_fk"
  add_foreign_key "pages", "photos", name: "pages_photos_id_fk"
  add_foreign_key "sessions", "devices"
  add_foreign_key "sessions", "users"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tracks", "photos", column: "waveform_photo_id", name: "tracks_photos_waveform_id_fk"
  add_foreign_key "tracks", "photos", name: "tracks_photos_id_fk"
  add_foreign_key "tracks", "social_links", name: "tracks_social_links_id_fk"
  add_foreign_key "user_likes", "pages"
  add_foreign_key "user_likes", "users"
  add_foreign_key "user_locations", "locations", name: "user_locations_locations_id_fk"
  add_foreign_key "user_locations", "sessions", name: "user_locations_sessions_id_fk"
  add_foreign_key "user_locations", "venues", name: "user_locations_venues_id_fk"
  add_foreign_key "user_rsvps", "events", name: "user_rsvps_events_id_fk"
  add_foreign_key "user_rsvps", "users", name: "user_rsvps_users_id_fk"
  add_foreign_key "users", "photos", name: "users_photos_id_fk"
  add_foreign_key "venue_messages", "users"
  add_foreign_key "venue_messages", "venues"
  add_foreign_key "venues", "locales"
  add_foreign_key "venues", "locations", name: "venues_locations_id_fk"
  add_foreign_key "venues", "pages"
end
