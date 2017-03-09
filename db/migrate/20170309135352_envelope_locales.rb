class EnvelopeLocales < ActiveRecord::Migration[5.0]
  def change
    rename_column :sessions, :geo_ip_location, :location

    add_column :locales, :envelope, :geography, srid: 4326, geographic: true, type: :polygon

    add_column :venues, :distance_tolerance, :integer
    add_column :venues, :envelope, :geography, srid: 4326, geographic: true, type: :polygon
  end
end
