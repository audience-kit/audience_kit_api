class CreateUserRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rsvps do |t|
      t.timestamps
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :event, type: :uuid, null: false, foreign_key: true
      t.string :state, null: false
    end
  end
end
