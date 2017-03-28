class UserAudience < ActiveRecord::Migration[5.0]
  def change
    create_table :user_audiences, id: :uuid do |t|
      t.timestamps
      t.references :audience, type: :uuid, null: false, foreign_key: true, indexed: true
      t.references :user, type: :uuid, null: false, foreign_key: true, indexed: true
      t.bigint :facebook_user_id, null: false, indexed: true
      t.string :facebook_token, null: false
    end

    add_index :user_audiences, [ :audience_id, :user_id ], unique: true
  end
end
