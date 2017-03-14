class UpdateSocialLinksJob < ApplicationJob
  def perform
    @sound_client = SoundCloud.new(:client_id => Rails.application.secrets['soundcloud']['id'])

    HotMessModels::SocialLink.all.each do |social_link|
      self.send "update_#{social_link.provider}".to_sym, social_link
    end
  end

  def update_facebook(social_link)

  end

  def update_soundcloud(social_link)
    puts "SoundCloud Update => #{social_link.handle}"

    tracks = @sound_client.get('/resolve', url: "https://soundcloud.com/#{social_link.handle}/tracks")

    tracks.each do |track|
      link = social_link.tracks.find_or_initialize_by(provider_identifier: track.permalink)
      link.created_at = track.created_at
      link.title = track.title
      link.provider_url = track.permalink_url
    end

    social_link.save
  end

  def update_twitter(social_link)

  end

  def update_instagram(social_link)

  end
end