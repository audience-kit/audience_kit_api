class Venue < ApplicationRecord
  belongs_to :locale

  has_many :events
end