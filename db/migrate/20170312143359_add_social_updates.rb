class AddSocialUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :social_updates, id: :uuid do |t|
      t.timestamps
      t.references :social_link, type: :uuid, null: false
      t.string :body, null: false
    end
  end
end
