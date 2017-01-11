class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events, id: :uuid do |t|
      t.timestamps

      t.string    :name
      t.datetime  :start_at
      t.datetime  :end_at
    end

    add_reference :events, :venue, type: :uuid, index: true, foreign_key: true
  end
end
