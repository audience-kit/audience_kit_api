class AddLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations, id: :uuid do |t|
      t.timestamps
      t.string      :google_place_id, null: false
      t.jsonb       :google_location, null: false
      t.geography   :location, limit: { srid: 4326, type: 'point', geographic: true }, null: false
      t.references  :locale, type: :uuid, null: false
    end
    add_index :locations, :google_place_id, unique: true

    # Create locations for existing venue google place ids
    execute 'INSERT INTO locations SELECT DISTINCT ON (venues.google_place_id) uuid_generate_v4(), venues.google_updated_at, venues.google_updated_at, venues.google_place_id, venues.google_location, venues.location, venues.locale_id FROM venues WHERE google_place_id IS NOT NULL'

    # Update the locales to point to the created location objects
    add_column :venues, :location_id, :uuid
    execute 'UPDATE venues SET location_id = (SELECT id FROM locations WHERE locations.google_place_id = venues.google_place_id)'

    # Insert city level location objects
    execute 'INSERT INTO locations SELECT DISTINCT ON (locales.google_place_id) uuid_generate_v4(), now(), now(), locales.google_place_id, locales.google_location, locales.location, locales.id FROM locales WHERE locales.google_place_id NOT IN (SELECT locations.google_place_id FROM locations)'

    # Update locales with city level locations
    add_column :locales, :location_id, :uuid
    execute 'UPDATE locales SET location_id = (SELECT id FROM locations WHERE locations.google_place_id = locales.google_place_id)'
    execute 'DELETE FROM locales WHERE beacon_major = 1'
    change_column_null :locales, :location_id, false

    # Remove duplicate columns after migration
    [ :locales, :venues ].each { |t| [  :google_place_id, :google_updated_at, :google_location, :location].each { |c| remove_column t, c } }
    [ :label, :country, :street, :state, :zip, :phone, :featured, :beacon_id ].each { |c| remove_column :venues, c }
  end
end
