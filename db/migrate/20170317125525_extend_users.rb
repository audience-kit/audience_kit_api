class ExtendUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :picture_image, :binary
    add_column :users, :picture_mime, :string
    add_column :users, :picture_url, :string
  end
end
