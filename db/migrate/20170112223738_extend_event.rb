class ExtendEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :facebook_id, :integer, limit: 8

    add_index :events, :facebook_id
  end
end
