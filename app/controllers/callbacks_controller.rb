class CallbacksController < ApplicationController
  def facebook_user
    logger.info params.inspect
  end

  def facebook_page
    logger.info params.inspect
  end

  # Delete all user content
  def facebook_deauthorize

  end
end