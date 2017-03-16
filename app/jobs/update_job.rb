class UpdateJob < ApplicationJob
  def perform(now = false)
    if now
      UpdateGooglePlaceJob.perform_now
      UpdatePagesJob.perform_now
      UpdateEnvelopeJob.perform_now
    else
      UpdateGooglePlaceJob.perform_later
      UpdatePagesJob.perform_later
      UpdateEnvelopeJob.perform_later
    end
  end
end