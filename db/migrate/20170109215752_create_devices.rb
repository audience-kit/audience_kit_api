class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices, id: :uuid do |t|
      t.timestamps

      t.string  :device_type
      t.string  :vendor_identifier
    end
  end
end
