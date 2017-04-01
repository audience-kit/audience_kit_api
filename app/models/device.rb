class Device < ApplicationRecord
  has_many :sessions

  validates_uniqueness_of :vendor_identifier, scope: :device_type
  validates_presence_of :vendor_identifier, :device_type

  def self.from_identifier(id, options = {})
    Device.find_or_create_by(vendor_identifier: id, device_type: options[:type])
  end
end
