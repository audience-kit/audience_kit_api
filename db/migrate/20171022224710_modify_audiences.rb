class ModifyAudiences < ActiveRecord::Migration[5.1]
  def change
    remove_column :audiences, :facebook_app_ids

    create_table :audience_applications, id: :uuid do |t|
      t.timestamps

      t.references :audiences, null: false, type: :uuid
      t.string :name, null: false
      t.bigint :facebook_app_id, null: false
      t.string :facebook_app_secret, null: false
    end

    create_table :audience_clients, id: :uuid do |t|
      t.timestamps

      t.references :audience_applications, null: false, type: :uuid
      t.string :token, null: false
    end
  end
end
