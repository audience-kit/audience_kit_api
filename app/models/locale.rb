class Locale < ApplicationRecord
  include Concerns::HasLocation

  has_many :venues
  has_many :people

  def update_data

  end
end