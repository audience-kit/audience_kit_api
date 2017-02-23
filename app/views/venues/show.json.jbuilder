json.venue do
  json.id @venue.id
  json.name @venue.name
  json.facebook_id @venue.facebook_id.to_s
  json.is_open @venue.is_open?
  json.photo_url "https://static.wixstatic.com/media/6d576695617ad2f8c0022066227abbe3.wix_mp_1024"

  json.hero_banner_url @venue.hero_banner_url

  if @venue.google_location
    json.address (@venue.street || "").gsub!(/,.+/, "")
    json.phone @venue.phone
  end
end