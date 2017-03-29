class CreateTribes < ActiveRecord::Migration[5.0]
  def change
    create_table :tribes, id: :uuid do |t|
      t.timestamps
      t.references :audience, type: :uuid, foriegn_key: true, null: false
      t.boolean :is_private, null: false, default: false
      t.string :handle, null: false
      t.string :description
    end

    add_index :tribes, [ :audience_id, :handle ], unique: true

    create_table :tribe_users, id: :uuid do |t|
      t.timestamps
      t.references :tribe, type: :uuid, null: false, foriegn_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
    end

    add_index :tribe_users, [ :tribe_id, :user_id ], unique: true

    add_column :users, :handle, :string, unique: true
  end
end
