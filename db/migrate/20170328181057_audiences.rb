class Audiences < ActiveRecord::Migration[5.0]
  def change
    create_table :audiences, id: :uuid do |t|
      t.timestamps
      t.string :hostname, null: false, unique: true
      t.bigint :production_facebook_id, unique: true, null: false
      t.bigint :stage_facebook_id
      t.bigint :development_facebook_id
    end
  end
end
