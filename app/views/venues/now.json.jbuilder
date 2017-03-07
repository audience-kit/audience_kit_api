json.title @venue.name

json.venue do
  json.partial! 'venue'
end

json.events do
  json.array! @events do |event|
    json.id event.id
    json.name event.display_name
    json.start_at event.start_at
    json.end_at event.end_at
    json.facebook_id event.facebook_id
    json.venue do
      json.id event.venue.id
      json.name event.venue.display_name
    end
  end
end

json.friends do
  json.array! @friends do |friend|
    json.id friend.id
    json.name friend.name
    json.facebook_id friend.facebook_id
  end
end