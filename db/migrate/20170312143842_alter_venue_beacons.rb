class AlterVenueBeacons < ActiveRecord::Migration[5.0]
  def change
    drop_table :venue_beacons

    create_table :location_beacons, id: :uuid do |t|
      t.references :location, type: :uuid, null: false
      t.integer :beacon_minor, null: false
    end
  end
end
