class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.timestamps

      t.uuid    :token_id
      t.string  :session_token
    end

    add_index :sessions, :token_id

    add_reference :sessions, :device, type: :uuid, index: true, foreign_key: true
    add_reference :sessions, :user, type: :uuid, index: true, foreign_key: true
  end
end
