class UsersController < ApplicationController
  skip_before_action :authenticate, only: [ :picture ]

  def me
    @user = user
  end

  def location
    @latitude = params[:coordinates][:latitude]
    @longitude = params[:coordinates][:longitude]

    @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude

    user_location = HotMessModels::UserLocation.new session: HotMessModels::Session.find_by(token_id: request.env['token_id']), point: @point

    user_location.venue = HotMessModels::Venue.closest @point, within: true
    Rails.logger.info "Location #{@point} registered venue as #{user_location.venue.id}" if user_location.venue

    # Override with becaons if available
    if params[:beacon] and params[:beacon][:major] != 0
      user_location.locale = HotMessModels::Locale.find_by(beacon_major: params[:beacon][:major])

      if params[:beacon][:minor] != 0
        user_location.beacon_minor = params[:beacon][:minor]

        user_location.venue = HotMessModels::Venue.find_by(locale: user_location.locale, beacon_id: user_location.beacon_minor)
      end
    end

    user_location.location = user_location.venue.location if user_location.venue
    user_location.location = HotMessModels::Locale.closest(@point).location unless user_location.location

    user_location.save

    kinesis = Aws::Kinesis::Client.new(
        region: 'us-west-2',
        credentials: Aws::Credentials.new(Rails.application.secrets[:aws_key_id], Rails.application.secrets[:aws_secret])
    )

    stream_name = "#{Rails.env}-hotmess-api"
    result = kinesis.put_record stream_name: stream_name, data: { type: :user_location_update, id: user_location.id, partition_key: user_location.user.id }
    puts "Kinesis user_location result => #{result}"
  end

  def picture
    redirect_to "/photos/#{user.photo_id}"
  end
end