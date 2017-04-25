# frozen_string_literal: true

json.person do
  json.partial! 'people/person_reference', person: @person
  json.cover_url @person.page.cover_photo&.cdn_url

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
      json.partial! 'tracks/track', track: track
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
        json.partial! 'venues/venue_reference', venue: event.venue
      end
    end
  end
end