class EventTempaltes < ActiveRecord::Migration[5.1]
  def change
    change_column_null :events, :facebook_id, false
    change_column_null :events, :facebook_graph, false

    create_table :event_templates, id: :uuid do |t|
      t.timestamps
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.references :venues, type: :uuid
      t.references :cover_photos, type: :uuid, foreign_key: { to_table: :photos }
    end

    add_reference :events, :event_templates, type: :uuid, null: true
  end
end
