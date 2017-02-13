class Event < ApplicationRecord
  belongs_to :venue
  belongs_to :person

  def update_details_from_facebook
    self.start_at  = self.facebook_graph['start_time']
    self.end_at    = self.facebook_graph['end_time']
    self.name      = self.facebook_graph['name']

    self.save
  end
end