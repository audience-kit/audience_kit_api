class AddNotificationToken < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :notification_token, :string
  end
end
