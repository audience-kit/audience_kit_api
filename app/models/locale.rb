class Locale < ApplicationRecord
  include Concerns::HasLocation

  has_many :venues
  has_many :people
  has_many :events, through: :venues

  def update_data

  end
end