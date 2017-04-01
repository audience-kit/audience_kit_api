class MoveLocationToPoint < ActiveRecord::Migration[5.0]
  def change
    rename_column :locations, :location, :point
  end
end
