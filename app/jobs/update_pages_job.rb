class UpdatePagesJob < ApplicationJob
  def perform
    Venue.where(hidden: false).order("pages.updated_at").includes(:page).each do |venue|
      Rails.logger.info "Updating Venue => #{venue.id} (#{venue.page.name})"
      VenueUpdater.new(venue).update
    end

    Person.includes(:page).order("pages.updated_at").each do |person|
      Rails.logger.info "Updating Person => #{person.id} (#{person.page.name})"
      PersonUpdater.new(person).update
    end
  end
end