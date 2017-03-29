class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews, id: :uuid do |t|
      t.timestamps
      t.references :page, type: :uuid, null: false, foriegn_key: true
      t.string :source
      t.references :user, type: :uuid, null: true, foriegn_key: true
      t.string :content
      t.integer :stars
    end
  end
end
