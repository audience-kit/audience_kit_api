class AddUserLocation < ActiveRecord::Migration[5.0]
  def change
    create_table :user_locations, id: :uuid do |table|
      table.timestamps

      table.references :users
      table.point :location, geographic: true
    end
  end
end
