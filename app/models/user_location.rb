class UserLocation < ApplicationRecord
  validates_presence_of :session, :point

  belongs_to :session
  belongs_to :venue

  scope :recent, -> { where('created_at > ?', 2.hours.ago) }

  def user
    session.user
  end

end
