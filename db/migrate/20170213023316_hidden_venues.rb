class HiddenVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :hidden, :boolean, default: false
    add_column :people, :requires_like, :boolean, default: false

    add_reference :events, :person, type: :uuid
  end
end
