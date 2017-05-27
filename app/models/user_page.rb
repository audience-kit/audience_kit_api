class UserPage < ApplicationRecord
  validates_presence_of :facebook_token

  belongs_to :user
  belongs_to :page
end