# frozen_string_literal: true

class Venue < ApplicationRecord
  include Concerns::Location

  belongs_to :page

  belongs_to :photo
  has_many :events, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }
  has_many :user_locations
  has_many :venue_messages

  belongs_to :locale

  delegate :name, to: :page

  def phone_number
    location[:phone_number]
  end

  def street
    location[:street]
  end

  def is_open?
    #TODO
    return nil unless location&.google_location

    utc_offset = location.google_location['utc_offset']

    operating_hours = location.google_location['opening_hours']
  end

  def update_data
    if self.location&.google_place_id
      location.update_location location.google_location['lng'], location.google_location['lat']

      self.save
    end
  end

  def hero_banner_url

  end

  def update_envelope
    return unless location&.point

    location.envelope = location.point.buffer(self.distance_tolerance)

    location.save
  end

  def display_name
    page.display_name
  end

  def facebook_id
    page.facebook_id
  end

  def to_layout
    venue = LayoutItem.new :venue
    venue.id = self.id
    venue.title = self.display_name
    venue.photo_url = self.photo&.cdn_url
    venue.description = "You're the first to arrive."
    venue.link_url = "https://hotmess.social/venues/#{self.id}"
    venue.distance = self['distance']
  end
end
