class Venue < ApplicationRecord
  include Concerns::HasLocation

  belongs_to :locale

  has_many :user_locations
  has_many :events
  has_many :users, through: :user_locations

  def is_open?
    #TODO
    return nil unless self.google_location

    utc_offset = self.google_location['utc_offset']

    operating_hours = self.google_location['opening_hours']
  end

  def update_data
    if self.google_location
      self.street = self.google_location['formatted_address']
      self.phone = self.google_location['formatted_phone_number']

      self.update_location self.google_location['lng'], self.google_location['lat']
    elsif self.facebook_graph
      self.street = self.facebook_graph['street']
      self.phone = self.facebook_graph['phone'] unless self.facebook_graph['phone'] == '<<not-applicable>>'

      if self.facebook_graph['latitude'] and self.facebook_graph['longitude']
        self.update_loction self.facebook_graph['longitude'], self.facebook_graph['latitude']
      else
        self.update_location_geocode self.street, self.facebook_graph['zip']
      end
    end
  end

  def hero_banner_url

  end
end