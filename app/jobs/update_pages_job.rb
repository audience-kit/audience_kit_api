class UpdatePagesJob < ApplicationJob
  def perform
    Venue.where(hidden: false).order("pages.updated_at").includes(:page).each do |venue|
      VenueUpdater.new(venue).update
    end

    Person.includes(:page).order("pages.updated_at").each do |person|
      PersonUpdater.new(person).update
    end
  end
end