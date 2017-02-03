class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.timestamps

      t.string    :name
      t.string    :email_address
      t.integer   :facebook_id, limit: 8
      t.string    :facebook_token
      t.datetime  :facebook_token_issued_at
      t.string    :profile_image_url
    end
  end
end
