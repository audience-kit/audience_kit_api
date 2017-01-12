class IndexUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :facebook_id
    add_index :users, :email_address

    add_index :venues, :facebook_id
    add_index :venues, :google_place_id
  end
end
