class ApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :applications, id: :uuid do |t|
      t.timestamps
      t.string :api_key, null: false, unique: true
    end
  end
end
