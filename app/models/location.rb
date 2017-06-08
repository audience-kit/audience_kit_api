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

  def self.from_google_place_id(place_id)
    location = self.find_or_initialize_by google_place_id: place_id

    client = ::GooglePlaces::Client.new(Rails.application.secrets.google_api_key)

    spot = client.spot place_id

    location.google_location = spot

    location.update_location spot['lng'], spot['lat']
    location.save

    location
  end
end
