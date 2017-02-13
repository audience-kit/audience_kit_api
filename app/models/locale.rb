class Locale < ApplicationRecord
  include Concerns::HasLocation

  has_many :venues
  has_many :people

  def self.closest(point)
    order("st_distance(location, '#{point.as_text}')").first
  end

  def update_data

  end
end