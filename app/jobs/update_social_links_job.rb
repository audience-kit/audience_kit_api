class UpdateSocialLinksJob < ApplicationJob
  def perform
    @sound_client = SoundCloud.new(client_id: Rails.application.secrets[:soundcloud][:id],
                                   client_secret: Rails.application.secrets[:soundcloud][:secret])

    SocialLink.all.each do |social_link|
      self.send "update_#{social_link.provider}".to_sym, social_link
    end
  end

  def update_facebook(social_link)

  end

  def update_soundcloud(social_link)
    puts "SoundCloud Update => #{social_link.handle}"

    tracks = @sound_client.get('/resolve', url: "https://soundcloud.com/#{social_link.handle}/tracks")

    tracks.each do |track_data|
      track = social_link.tracks.find_or_initialize_by(provider_identifier: track_data.permalink)
      track.created_at = track_data.created_at
      track.title = track_data.title
      track.provider_url = track_data.permalink_url
      track.photo = Photo.for_url track_data.artwork_url
      track.waveform_photo = Photo.for_url track_data.waveform_url
      track.download_url = track_data.download_url
      track.stream_url = track_data.stream_url
      track.metadata = track_data
    end

    social_link.save
  end

  def update_twitter(social_link)

  end

  def update_instagram(social_link)

  end
end