# frozen_string_literal: true

class TribeUser < ApplicationRecord
  belongs_to :tribe
  belongs_to :user
end
