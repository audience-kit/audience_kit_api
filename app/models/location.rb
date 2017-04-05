# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :photo
  has_one :venue
  has_one :locale

  def name
    self.google_location['name']
  end

  def update_location(longitude, latitude)
    puts "Location => #{self}"
    self.point = RGeo::Geographic.simple_mercator_factory.point longitude, latitude
  end
end
