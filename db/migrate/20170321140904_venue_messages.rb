class VenueMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :venue_messages, id: :uuid do |t|
      t.timestamps
      t.references :venue, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true
      t.string :message
    end
  end
end
