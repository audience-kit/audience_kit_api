class UpdateJob < ApplicationJob


  def perform(now = false)
    if now
      UpdateGooglePlaceJob.perform_now
      UpdatePeopleJob.perform_now(true)
      UpdateVenuesJob.perform_now(true)
      UpdateEnvelopeJob.perform_now
    else
      UpdateGooglePlaceJob.perform_later
      UpdatePeopleJob.perform_later(false)
      UpdateVenuesJob.perform_later(false)
      UpdateEnvelopeJob.perform_later
    end
  end
end