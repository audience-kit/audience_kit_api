class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.timestamps

      t.uuid :user_id
      t.uuid :device_id

    end
  end
end
