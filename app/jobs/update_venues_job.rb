class UpdateVenuesJob < ApplicationJob
  queue_as :default

  def perform(now = false)
    HotMessModels::Venue.all.order(facebook_updated_at: :desc).each do |venue|
      if now
        UpdateVenueJob.perform_now venue
      else
        UpdateVenueJob.perform_later venue
      end
    end
  end
end
