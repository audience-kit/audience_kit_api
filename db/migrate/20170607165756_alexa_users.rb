class AlexaUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :alexa_users, id: :uuid do |t|
      t.timestamps
      t.string :user_id, null: false
      t.references :user, type: :uuid, null: true, foreign_key: true
    end

    create_table :audiences, id: :uuid do |t|
      t.timestamps
      t.string :name, null: false
      t.string :subdomain, null: false, unique: true
      t.bigint :facebook_app_ids, array: true, null: false
    end

    create_table :audience_users, id: :uuid do |t|
      t.timestamps
      t.references :audience, type: :uuid, foreign_key: true, null: false
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.bigint :facebook_id, null: false, unique: true
    end

    add_reference :people, :audience, type: :uuid, foreign_key: true
    add_reference :venues, :audience, type: :uuid, foriegn_key: true
    
  end
end
