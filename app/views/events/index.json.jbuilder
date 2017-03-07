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
      json.facebook_id event.venue.facebook_id
    end

    if event.person
      json.person do
        json.id event.person.id
        json.name event.person.display_name
        json.facebook_id event.person.facebook_id
      end
    end
  end
end