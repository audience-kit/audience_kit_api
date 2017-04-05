# frozen_string_literal: true

json.id @venue.id
json.name @venue.display_name
json.facebook_id @venue.facebook_id.to_s
json.is_open true
json.photo_url @venue.location.photo&.cdn_url || 'https://api.hotmess.social./homepage_background.jpg'

json.hero_banner_url @venue.hero_banner_url
json.friend_count 0

if @venue.location&.google_location
  json.address (@venue.street || "").gsub!(/,.+/, "")
  json.phone @venue.phone_number
end
