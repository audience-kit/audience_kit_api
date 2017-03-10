json.title @title
json.image_url @image_url

if @venue
  json.venue do
    json.partial! 'venue'
  end

  json.friends do
    json.array! @friends do |friend|
      json.id friend.id
      json.name friend.name
      json.facebook_id friend.facebook_id
    end
  end
else
  json.venues do
    json.array! @venues do |venue|

      json.id venue.id
      json.name venue.display_name
      json.facebook_id venue.facebook_id.to_s
      json.is_open venue.is_open?
      json.photo_url "#{venue_url(venue)}/photo"
      json.description "You're the first to arrive."

      json.hero_banner_url venue.hero_banner_url
      json.friend_count 0

      if venue.google_location
        json.address (venue.street || "").gsub!(/,.+/, "")
        json.phone venue.phone
      end

    end
  end
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

