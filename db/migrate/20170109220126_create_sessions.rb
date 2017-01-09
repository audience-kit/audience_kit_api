class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions, id: :sessions do |t|
      t.timestamps

      t.uuid  :device_id
      t.uuid  :user_id
      t.uuid  :token_id
    end

    add_index :sessions, :token_id

    add_reference :sessions, :device, index: true, foreign_key: true
    add_reference :sessions, :user, index: true, foreign_key: true
  end
end
