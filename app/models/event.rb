class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :person

  delegate :locale, :to => :venue, :allow_nil => true

  scope :future, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }

  def update_details_from_facebook
    self.start_at  = self.facebook_graph['start_time']
    self.end_at    = self.facebook_graph['end_time']
    self.name      = self.facebook_graph['name']

    self.save
  end
end