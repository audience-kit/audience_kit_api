class AddTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks, id: :uuid do |t|
      t.timestamps
      t.references :social_link, type: :uuid, null: false
      t.string :title, null: false
      t.string :provider_url, null: false
      t.string :provider_identifier, null: false
    end
  end
end
