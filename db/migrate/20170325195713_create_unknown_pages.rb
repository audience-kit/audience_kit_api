class CreateUnknownPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :hidden, :boolean, default: false, null: false

    create_table :user_event_rsvp, id: :uuid do |t|
      t.timestamps
      t.references :event, type: :uuid, foreign_key: true, null: false
      t.references :user, type: :uuid, forign_key: true, null: false
      t.string :state, null: false
    end
  end
end
