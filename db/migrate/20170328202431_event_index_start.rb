class EventIndexStart < ActiveRecord::Migration[5.0]
  def change
    add_index :events, :start_at
  end
end
