class AddDiagnostic < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :last_update_error, :string, null: true

    add_reference :users, :venue, type: :uuid, null: true, foreign_key: true
    add_column :users, :venue_last_at, :datetime, null: true
  end
end
