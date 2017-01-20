class AddGeography < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'postgis'

    add_column :locales, :location, :geography
    add_column :venues, :location, :geography

    add_column :sessions, :geo_ip_location, :geography
  end
end
