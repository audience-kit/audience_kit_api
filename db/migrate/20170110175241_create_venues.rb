class CreateVenues < ActiveRecord::Migration[5.0]
  def change
    create_table :venues, id: :uuid do |t|
      t.timestamps

      t.string :name
      t.integer :facebook_id, limit: 8
    end
  end
end
