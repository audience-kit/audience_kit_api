json.title @title
json.image_url @image_url

json.locale do
  json.id @locale.id
  json.name @locale.name
end

if @venue
  json.venue do
    json.partial! 'venue'

    json.messages do
      json.array! @venue.venue_messages do |message|
        json.id message.id
        json.sent_at message.created_at
        json.sending_user_id message.user_id
        json.message message.message
      end
    end
  end
else
  json.venues do
    json.array! @venues do |venue|

      json.id venue.id
      json.name venue.display_name
      json.facebook_id venue.facebook_id.to_s
      json.is_open true
      json.photo_url (venue.photo ? photo_url(venue.photo) : 'https://api.hotmess.social./homepage_background.jpg')
      json.description "You're the first to arrive."
      json.distance venue['distance']

      json.hero_banner_url venue.hero_banner_url
      json.friend_count 0

      if venue.location&.google_location
        json.address (venue.street || "").gsub!(/,.+/, "")
        json.phone venue.phone_number
      end

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

