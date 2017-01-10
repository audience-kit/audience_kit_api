class CreateVenues < ActiveRecord::Migration[5.0]
  def change
    create_table :locales, id: :uuid do |t|
      t.timestamps

      t.string :label
      t.string :name
    end

    create_table :venues, id: :uuid do |t|
      t.timestamps

      t.string :name
      t.integer :facebook_id, limit: 8
    end

    add_reference :venues, :locale, type: :uuid, index: true, foreign_key: true
  end
end
