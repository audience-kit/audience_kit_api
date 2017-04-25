# frozen_string_literal: true

json.partial! 'events/event_core', event: event

json.venue do
  json.id event.venue.id
  json.name event.venue.display_name
  json.facebook_id event.venue.facebook_id.to_s
  json.is_open event.venue.is_open?
  json.photo_url event.venue.page.photo&.cdn_url
  json.hero_url event.venue.location&.photo&.cdn_url

  if event.venue.location&.google_location
    json.address((event.venue.street || '').gsub(/,.+/, ''))
    json.phone event.venue.phone_number
  end

end

json.people do
  json.array! event.people do |person|
    json.partial! 'people/person_reference', person: person
    json.role 'host'
  end
end

json.ticket_types do
  event.ticket_types.each do |ticket_type|
    json.partial! 'events/ticket_type', ticket_type: ticket_type
  end
end