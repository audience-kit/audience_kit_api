
json.id @venue.id
json.name @venue.display_name
json.facebook_id @venue.facebook_id.to_s
json.is_open true
json.photo_url "#{venue_url(@venue)}/photo"

json.hero_banner_url @venue.hero_banner_url
json.friend_count 0

if @venue.google_location
  json.address (@venue.street || "").gsub!(/,.+/, "")
  json.phone @venue.phone_number
end
