class Person < ApplicationRecord
  belongs_to :locale

  has_many :events, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }
end