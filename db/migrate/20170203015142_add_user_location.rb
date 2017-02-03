class AddUserLocation < ActiveRecord::Migration[5.0]
  def change
    create_table :user_locations do |table|
      table.timestamps

      table.references :users
    end

    add_column :user_locations, :location, type: :geography
  end
end
