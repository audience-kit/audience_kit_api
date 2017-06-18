# frozen_string_literal: true

json.id @venue.id
json.name @venue.display_name
json.facebook_id @venue.facebook_id.to_s
json.is_open true
json.photo_url @venue.page.photo&.cdn_url
json.hero_url @venue.location.photo&.cdn_url

json.cover_photos do
  json.array! [ @venue.page.photo ] do |photo|
    json.url photo.cdn_url
  end
end

json.hero_banner_url @venue.hero_banner_url
json.friend_count 0

if @venue.location&.google_location
  json.address @venue.street
  json.phone @venue.phone_number
end
