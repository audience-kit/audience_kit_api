class UserLocation < ApplicationRecord
  belongs_to :user
  belongs_to :locale
  belongs_to :venue

  scope :recent, -> { where("created_at > ?", 2.hours.ago) }
end
