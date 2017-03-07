json.person do
  json.id @person.id
  json.name @person.display_name
  json.facebook_id @person.facebook_id

  json.events do
    json.array! @person.events do |event|
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
end