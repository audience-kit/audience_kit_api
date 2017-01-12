class ExtendSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :sessions, :origin_ip, :inet

    add_column :users, :facebook_graph, :jsonb
    add_column :events, :facebook_graph, :jsonb

    add_column :devices, :bluetooth_address, :macaddr
    add_column :devices, :wifi_address, :macaddr
  end
end
