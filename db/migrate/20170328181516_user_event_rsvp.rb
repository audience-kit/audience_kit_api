class UserEventRsvp < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rsvp, id: :uuid do |t|
      t.timestamps
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :state, null: false
    end

    add_index :user_rsvp, [ :event_id, :user_id ], unique: true
  end
end
