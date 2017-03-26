class CallbacksController < ApplicationController
  skip_before_action :authenticate

  def facebook_user
    params[:entry].each { |entry| kinesis :facebook_user_callback, entry[:id], id: entry[:id] }
  end

  def facebook_page
    params[:entry].each { |entry| kinesis :facebook_page_callback, entry[:id], id: entry[:id] }
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