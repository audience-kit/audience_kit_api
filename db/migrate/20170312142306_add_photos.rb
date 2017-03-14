class AddPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos, id: :uuid do |t|
      t.timestamps
      t.string :source_url, null: false
      t.string :hash, null: false
      t.binary :content, null: false
    end

    # Add nullable fields to host photos on person and venue
    add_reference :people, :photo, type: :uuid
    add_reference :venues, :photo, type: :uuid

    add_column :venues, :hero_banner_id, :uuid
    add_foreign_key :venues, :photos, column: :hero_banner_id
  end
end
