class Location < ApplicationRecord
  belongs_to :photo
  has_one :venue
  has_one :locale
end