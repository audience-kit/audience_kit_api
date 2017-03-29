class ApplicationTokens < ActiveRecord::Migration[5.0]
  def change
    remove_column :audiences, :production_facebook_id
    remove_column :audiences, :stage_facebook_id
    remove_column :audiences, :development_facebook_id

    create_table :applications, id: :uuid do |t|
      t.timestamps
      t.references :audiences, type: :uuid, null: false, foriegn_key: true
      t.bigint :facebook_id, null: false, unique: true
      t.string :environment
    end

    create_table :application_tokens, id: :uuid do |t|
      t.timestamps
      t.references :application, type: :uuid, null: false, foreign_key: true
      t.string :token, null: false, unique: true
    end
  end
end
