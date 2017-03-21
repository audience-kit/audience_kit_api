class AddUserLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_likes, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :page, type: :uuid, foreign_key: true, null: false
    end
  end
end
