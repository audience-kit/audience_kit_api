class Locale < ApplicationRecord
  has_many :venues
  has_many :people

  def self.closest(point)
    order("st_distance(location, '#{point.as_text}')").first
  end
end