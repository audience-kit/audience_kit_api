class CallbacksController < ApplicationController
  skip_before_action :authenticate

  def kinesis(partition, data)
    @kinesis_client ||= Aws::Kinesis::Client.new(region: 'us-west-2', credentials: AWS_CREDENTIALS)

    kinesis.put_record stream_name: "#{Rails.env}-hotmess-api", data: data.to_json, partition_key: partition
  end

  def facebook_user
    params[:entry].each { |entry| kinesis entry[:id], type: :facebook_user_callback, id: entry[:id] }
  end

  def facebook_page
    params[:entry].each { |entry| kinesis entry[:id], type: :facebook_page_callback, id: entry[:id] }
  end

  def facebook_verify
    if params['hub.mode'] == 'subscribe' and params['hub.verify_token'] == Rails.application.secrets[:facebook_callback_secret]
      render text: params['hub.challenge']
    else
      render status: :bad_request
    end
  end

  # Delete all user content
  def facebook_deauthorize

  end
end