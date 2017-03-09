class UpdateEnvelopeJob < ApplicationJob
  def perform
    HotMessModels::Venue.all.each do |venue|
      puts "Updating Envelope for Venue -> #{venue.display_name}"
      venue.update_envelope
      venue.save
    end

    HotMessModels::Locale.all.each do |locale|
      puts "Updating Envelope for Locale -> #{locale.name}"
      locale.update_envelope
      locale.save
    end
  end
end