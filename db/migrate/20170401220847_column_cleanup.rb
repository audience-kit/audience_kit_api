class ColumnCleanup < ActiveRecord::Migration[5.0]
  def change
    remove_column :venues, :photo_id
    remove_column :venues, :hero_banner_id
    remove_column :venues, :envelope

    add_column :locations, :envelope, :geography, srid: 4326, geographic: true, type: :polygon

    change_column_null :venues, :page_id, false
  end
end
