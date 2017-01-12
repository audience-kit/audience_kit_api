class Device < ApplicationRecord
  has_many :sessions


  def self.from_identifier(id, options = {})
    type = options[:type]

    Device.find_or_create_by(vendor_identifier: id, device_type: type)
  end
end