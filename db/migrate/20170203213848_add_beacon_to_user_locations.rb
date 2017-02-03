class AddBeaconToUserLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locales, :beacon_major, :integer
    add_column :user_locations, :beacon_minor, :integer

    add_reference :user_locations, :locales
    add_reference :user_locations, :venues
  end
end
