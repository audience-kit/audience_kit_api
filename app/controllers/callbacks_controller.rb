class CallbacksController < ApplicationController
  skip_before_action :authenticate

  def facebook_user
    params[:entry].each do |entry|
      user = HotMessModels::User.find_by(facebook_id: entry[:id])

      UpdateUserJob.perform_later user if user
    end
  end

  def facebook_page
    params[:entry].each do |entry|
      page = HotMessModels::Venue.find_by(facebook_id: entry[:id])

      if page
        UpdateVenueJob.perform_later page
      else
        page = HotMessModels::Person.find_by(facebook_id: entry[:id])

        UpdatePersonJob.perform_later page if page
      end
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