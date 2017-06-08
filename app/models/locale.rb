# frozen_string_literal: true

class Locale < ApplicationRecord
  ZIP_EXPRESSION = /\d{5}/

  include Concerns::Location

  has_many :venues
  has_many :people
  has_many :events, through: :venues
  has_many :locations

  belongs_to :location

  def update_envelope
    return unless venues.any?

    factory = RGeo::Geographic.simple_mercator_factory

    venue_points = venues.where(hidden: false).map(&:location).reject(&:nil?).to_a
    all_points = factory.collection venue_points
    envelope = all_points.envelope
    self.envelope = envelope
  end

  def from_locale_name(name)
    location = Geocoder.search(name).first if ZIP_EXPRESSION =~ name
    location = Locale.where('? = ANY(city_names)', params[:locale]).first.location.point unless location

    point = RGeo::Geographic.simple_mercator_factory.point location.longitude, location.latitude

    Locale.closest(point)
  end
end
