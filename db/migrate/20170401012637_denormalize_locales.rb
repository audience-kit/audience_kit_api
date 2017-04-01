class DenormalizeLocales < ActiveRecord::Migration[5.0]
  def change
    add_column :locales, :point, :point, srid: 4326, geographic: true
    add_column :locales, :google_location, :jsonb
    add_column :locales, :google_place_id, :string

    execute 'UPDATE locales SET google_place_id = (SELECT google_place_id FROM locations WHERE id = locales.location_id LIMIT 1)'
    execute 'UPDATE locales SET google_location = (SELECT google_location FROM locations WHERE id = locales.location_id LIMIT 1)'
  end
end
