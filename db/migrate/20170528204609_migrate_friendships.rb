class MigrateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendship_link, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, null: false
      t.references :friend, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :friendship, type: :uuid, null: false
    end
  end
end
