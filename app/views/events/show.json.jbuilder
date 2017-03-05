json.event do
  json.id @event.id
  json.name @event.name
  json.start_at @event.start_at
  json.end_at @event.end_at
  json.facebook_id @event.facebook_id
  json.venue do
    json.id @event.venue.id
    json.name @event.venue.name
    json.facebook_id @event.venue.facebook_id.to_s
    json.is_open @event.venue.is_open?
    json.photo_url "#{venue_url(@event.venue)}/photo"

    json.hero_banner_url @event.venue.hero_banner_url

    if @event.venue.google_location
      json.address (@event.venue.street || "").gsub!(/,.+/, "")
      json.phone @event.venue.phone
    end

  end

  if @event.person
    json.person do
      json.id @event.person.id
      json.name @event.person.display_name
      json.facebook_id @event.person.facebook_id
    end
  end
end