# frozen_string_literal: true

class TicketType < ApplicationRecord
  has_many :user_rsvps
  belongs_to :event
end
