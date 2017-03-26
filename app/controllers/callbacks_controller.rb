class CallbacksController < ApplicationController
  skip_before_action :authenticate

  def facebook_user
    kinesis = Aws::Kinesis::Client.new(
        region: 'us-west-2',
        credentials: Aws::Credentials.new Rails.application.secrets[:aws_key_id], Rails.application.secrets[:aws_secret]
    )

    stream_name = "#{Rails.env}-hotmess-api"

    params[:entry].each do |entry|
      kinesis.put_record stream_name: stream_name, data: { type: :facebook_user_callback, id: entry[:id], partition_key: entry[:id] }
    end
  end

  def facebook_page
    kinesis = Aws::Kinesis::Client.new(
        region: 'us-west-2',
        credentials: Aws::Credentials.new Rails.application.secrets[:aws_key_id], Rails.application.secrets[:aws_secret]
    )

    stream_name = "#{Rails.env}-hotmess-api"

    params[:entry].each do |entry|
      kinesis.put_record stream_name: stream_name, data: { type: :facebook_page_callback, id: entry[:id], partition_key: entry[:id] }
    end
  end

  def facebook_verify
    if params['hub.mode'] == 'subscribe' and params['hub.verify_token'] == Rails.application.secrets.facebook_callback_secret
      render text: params['hub.challenge']
    else
      render status: :bad_request
    end
  end

  # Delete all user content
  def facebook_deauthorize

  end
end