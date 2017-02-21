class AddSocialLinks < ActiveRecord::Migration[5.0]
  def change
    remove_column :venues, :is_hidden

    add_column :people, :instagram, :string
    add_column :people, :sound_cloud, :string
    add_column :people, :twitter, :string

    add_column :people, :featured, :boolean
    add_column :venues, :featured, :boolean
    add_column :events, :featured, :boolean

    create_table :venue_mapping, id: :uuid do |t|
      t.references :venue
      t.bigint :facebook_id
    end

    create_table :friendships, id: :uuid do |t|
      t.timestamp

      t.references :friend_high, type: :uuid, foreign_key: { to_table: :users }
      t.references :friend_low, type: :uuid, foreign_key: { to_table: :users }

      t.date :friends_at
      t.string :friend_hash
      t.integer :weight
    end

    create_table :venue_beacons, id: :uuid do |t|
      t.references :venue

      t.integer :beacon_id
    end

    create_table :person_locales, id: :uuid do |t|
      t.references :person
      t.references :locale
    end
  end
end
