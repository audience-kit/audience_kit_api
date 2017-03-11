class CallbacksController < ApplicationController
  skip_before_action :authenticate

  def facebook_user
    logger.info params.inspect
  end

  def facebook_page
    logger.info params.inspect
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