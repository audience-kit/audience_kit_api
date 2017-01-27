class VenueGooglePlaceId < ActiveRecord::Migration[5.0]
  def change
    add_column :locales, :google_place_id, :string
    add_column :locales, :google_updated_at, :datetime
  end
end
