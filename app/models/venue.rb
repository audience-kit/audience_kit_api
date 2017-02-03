class Venue < ApplicationRecord
  belongs_to :locale

  has_many :events


  def is_open?
    return nil unless self.google_location

    utc_offset = self.google_location['utc_offset']

    operating_hours = self.google_location['opening_hours']
  end
end