class AddEventPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :event_people, id: :uuid do |t|
      t.timestamps
      t.references  :person, type: :uuid, null: false
      t.references  :event, type: :uuid, null: false
      t.string      :role, null: false
    end

    # For now the only relation type is 'host'
    execute "INSERT INTO event_people SELECT uuid_generate_v4(), created_at, updated_at, person_id, id, 'host' as role FROM events WHERE person_id IS NOT NULL"

    # Remove duplicate migrated columns
    [ :person_id, :featured ].each { |c| remove_column :events, c }
  end
end
