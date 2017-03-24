class AddUserScopesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_scopes, :string, array: true
  end
end
