# frozen_string_literal: true

class LocationBeacon < ApplicationRecord
  has_one :venue
end
