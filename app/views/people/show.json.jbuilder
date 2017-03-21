json.person do
  json.id @person.id
  json.name @person.display_name
  json.facebook_id @person.facebook_id
  json.is_liked @is_liked

  json.social_links do
    json.array! @person.social_links do |link|
      json.id link.id
      json.provider link.provider
      json.handle link.handle
      json.url link.url
    end
  end

  json.tracks do
    json.array! @person.tracks.sort_by(&:created_at).take(5) do |track|
      json.id track.id
      json.released_at track.created_at
      json.title track.title
      json.provider track.social_link.provider
      json.provider_url track.provider_url
      json.stream_url track.stream_url
      json.download_url track.download_url
      json.artwork_url artwork_track_url(track)
      json.waveform_url waveform_track_url(track)
    end
  end

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