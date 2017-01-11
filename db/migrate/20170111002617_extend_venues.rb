class ExtendVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :facebook_updated_at, :datetime
    add_column :venues, :label, :string
    add_column :venues, :is_hidden, :boolean, default: false
    add_column :venues, :country, :string
    add_column :venues, :state, :string
    add_column :venues, :zip, :string
    add_column :venues, :street, :string
    add_column :venues, :phone, :string
    add_column :venues, :google_place_id, :string
    add_column :venues, :google_updated_at, :datetime
  end

end
