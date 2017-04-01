class TribeUser < ApplicationRecord
  belongs_to :tribe
  belongs_to :user
end
