json.events do
  json.array! @events do |event|
    json.id event.id
    json.name event.name
    json.start_at event.start_at
    json.end_at event.end_at
    json.venue do
      json.id event.venue.id
      json.name event.venue.name
    end
  end
end