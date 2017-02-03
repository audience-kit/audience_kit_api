class AddUserLocation < ActiveRecord::Migration[5.0]
  def change
    create_table do |table|
      table.timestamps

      table.geography :location
      table.references :user
    end
  end
end
