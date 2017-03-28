class AddIndexes < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_event_rsvp

    rename_table :user_rsvp, :user_rsvps


    add_index :event_people, [ :event_id, :person_id ]
    add_index :event_people, [ :event_id, :person_id, :role ], unique: true

    add_index :friendships, :friend_hash, unique: true

    add_foreign_key :people, :pages, column: :page_id

    add_index :social_links, [ :object_id, :provider, :handle ], unique: true

    add_index :user_likes, [ :user_id, :page_id ], unique: true

    remove_index :venue_pages, name: :venue_pages_unique_key

    add_index :venue_pages, [ :venue_id, :page_id ], unique: true

    add_column :audiences, :beacon_uuid, :uuid, null: false

    add_foreign_key :venues, :photos, column: :photo_id
  end
end
