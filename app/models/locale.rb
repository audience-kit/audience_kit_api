class Locale < ApplicationRecord
  include Concerns::Location


  has_many :venues
  has_many :people
  has_many :events, through: :venues
  has_many :locations

  def update_envelope
    return unless venues.any?

    factory = RGeo::Geographic.simple_mercator_factory

    venue_points = venues.where(hidden: false).map { |v| v.location }.select { |l| l }.to_a
    all_points = factory.collection venue_points
    envelope = all_points.envelope
    self.envelope = envelope
  end
end
