class AddGoogleLocationJson < ActiveRecord::Migration[5.0]
  def change
    add_column :locales, :google_location, :jsonb
    add_column :venues, :google_location, :jsonb
  end
end
