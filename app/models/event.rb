class Event < ApplicationRecord
  validates_presence_of :name

  belongs_to :venue
  has_many :event_people
  has_many :ticket_types
  has_many :people, through: :event_people
  has_many :rsvps, class_name: 'UserRSVP'
  belongs_to :cover_photo, class_name: 'Photo'

  delegate :locale, to: :venue

  scope :future, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }

  def update_details_from_facebook
    self.start_at  = self.facebook_graph['start_time']
    self.end_at    = self.facebook_graph['end_time']
    self.name      = self.facebook_graph['name']

    self.save
  end

  def display_name
    self.name_override || self.name
  end

  def person
    first = event_people.first

    first ? first.person : nil
  end
end
