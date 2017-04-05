# frozen_string_literal: true

json.partial! 'events/event_core', event: event

json.venue do
  json.id event.venue.id
  json.name event.venue.display_name
  json.facebook_id event.venue.facebook_id
end

if event.person
  json.person do
    json.id event.person.id
    json.name event.person.display_name
    json.facebook_id event.person.facebook_id
  end
end