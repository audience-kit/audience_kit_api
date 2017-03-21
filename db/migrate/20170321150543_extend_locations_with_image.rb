class ExtendLocationsWithImage < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :hero_url, :string
    add_column :locations, :hero_image, :binary
    add_column :locations, :hero_mime, :string
  end
end
