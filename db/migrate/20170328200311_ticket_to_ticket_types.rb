class TicketToTicketTypes < ActiveRecord::Migration[5.0]
  def change
    rename_table :tickets, :ticket_types

    rename_column :user_rsvps, :ticket_id, :ticket_type_id
  end
end
