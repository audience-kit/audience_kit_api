json.event do
  json.id @event.id
  json.name @event.name
  json.start_at @event.start_at
  json.end_at @event.end_at
  json.facebook_id @event.facebook_id
  json.venue do
    json.id @event.venue.id
    json.name @event.venue.name
  end

  if @event.person
    json.person do
      json.id @event.person.id
      json.name @event.person.display_name
    end
  end
end