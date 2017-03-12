class AddSocialLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :social_links, id: :uuid do |t|
      t.timestamps
      t.uuid :object_id, null: false
      t.string :type, null: false
      t.string :handle, null: false
      t.boolean :primary, null: false, default: false
    end
  end
end
