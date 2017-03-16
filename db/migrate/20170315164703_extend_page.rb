class ExtendPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :picture_url, :string
    add_column :pages, :picture_mime, :string
    add_column :pages, :picture_image, :binary
    add_column :pages, :cover_url, :string
    add_column :pages, :cover_mime, :string
    add_column :pages, :cover_image, :binary
    add_column :pages, :requires_user_token, :boolean, null: false, default: false
  end
end
