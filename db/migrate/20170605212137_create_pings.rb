class CreatePings < ActiveRecord::Migration[5.1]
  def change
    create_table :pings, id: :uuid do |t|
      t.timestamps
      t.references :user, type: :uuid, null: false, foriegn_key: true
      t.references :locale, type: :uuid, null: false, foreign_key: true
    end
  end
end
