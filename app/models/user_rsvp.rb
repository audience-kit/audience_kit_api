# frozen_string_literal: true

class UserRSVP < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates_presence_of :user, :event, :state

  after_initialize do
    self.state ||= 'unsure'
  end
end
