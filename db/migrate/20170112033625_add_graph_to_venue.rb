class AddGraphToVenue < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :facebook_graph, :jsonb
  end
end
