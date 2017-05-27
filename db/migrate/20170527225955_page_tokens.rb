class PageTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_pages, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, null: false
      t.references :page, type: :uuid, null: false
      t.string :facebook_token, null: false
    end
  end
end
