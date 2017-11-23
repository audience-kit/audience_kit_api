class CreateSafetyReports < ActiveRecord::Migration[5.1]
  def change
    add_column :pings, :is_safety, :boolean, null: false, default: false
    add_column :friendships, :is_circle, :boolean, null: false, default: false

    create_table :safety_reports, id: :uuid do |t|
      t.timestamps

      t.string :types, array: true, null: false
      t.geography :point, limit: { srid: 4326, type: 'st_point', geographic: true }, null: true
    end

    create_table :safety_report_identifiers, id: :uuid do |t|
      t.references :safety_reports, type: :uuid, null: false
      t.string :type, null: false
      t.string :value, null: false
    end
  end
end
