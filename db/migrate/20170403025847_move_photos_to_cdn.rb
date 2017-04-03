class MovePhotosToCdn < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :cdn_url, :string
  end
end
