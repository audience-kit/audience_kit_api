class UserLocation < ApplicationRecord
  belongs_to :user
  belongs_to :locale
  belongs_to :venue
end
