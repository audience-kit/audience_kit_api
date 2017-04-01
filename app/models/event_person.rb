class EventPerson < ApplicationRecord
  validates_presence_of :role

  belongs_to :person
  belongs_to :event
end
