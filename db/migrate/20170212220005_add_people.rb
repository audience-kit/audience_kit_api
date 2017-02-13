class AddPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people, id: :uuid do |t|
      t.timestamps

      t.references  :locale, type: :uuid
      t.bigint      :facebook_id, null: false
      t.jsonb       :facebook_graph
      t.datetime    :facebook_updated_at
      t.references  :venue, type: :uuid
      t.string      :display_name
      t.string      :facebook_token
    end
  end
end
