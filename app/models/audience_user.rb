class AudienceUser < ApplicationRecord
  belongs_to :audience
  belongs_to :user

  validates_presence_of :facebook_token
end
