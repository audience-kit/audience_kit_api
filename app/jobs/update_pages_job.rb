class UpdatePagesJob < ApplicationJob
  def perform
    Venue.where(hidden: false).includes(:page).each do |venue|
      VenueUpdater.new(venue).update
    end

    Person.includes(:page).each do |person|
      PersonUpdater.new(person).update
    end
  end
end