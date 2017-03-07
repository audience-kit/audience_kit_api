class Person < ApplicationRecord
  belongs_to :locale

  has_many :events, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }

  def display_name
    self.name_override || self.name
  end
end