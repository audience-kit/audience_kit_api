class Audience < ApplicationRecord
  has_many :users

  validates_presence_of :hostname, :production_facebook_id
end
