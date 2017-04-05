# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_types, id: :uuid do |t|
      t.timestamps
      t.references :event, type: :uuid, foreign_key: true, null: false
      t.decimal :price
      t.boolean :available, null: false, default: true
      t.string :provider, null: false
      t.string :provider_id, null: false
    end
  end
end
