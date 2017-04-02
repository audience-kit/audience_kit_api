class Location < ApplicationRecord
  belongs_to :photo
  has_one :venue
  has_one :locale

  def name
    self.google_location['name']
  end
end