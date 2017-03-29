class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets, id: :uuid do |t|
      t.timestamps
      t.references :event, type: :uuid, foreign_key: true, null: false
      t.string :title, null: false
      t.string :provider_ticket_id, null: false
      t.money :price, null: true
    end

    add_reference :user_rsvps, :ticket, type: :uuid

    add_column :user_rsvps, :ticket_quantity, :integer

    add_column :events, :ticket_provider, :string
    add_column :events, :ticket_provider_id, :string
  end
end
