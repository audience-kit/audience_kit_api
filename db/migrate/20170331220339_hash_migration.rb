class HashMigration < ActiveRecord::Migration[5.0]
  def change
    rename_column :photos, :hash, :content_hash
  end
end
