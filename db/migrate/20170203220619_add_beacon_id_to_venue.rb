class AddBeaconIdToVenue < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :beacon_id, :integer
  end
end
