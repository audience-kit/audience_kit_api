class UpdatePagesJob < ApplicationJob
  def perform
    Venue.where(hidden: false).each do |venue|
      VenueUpdater.new(venue).update
    end

    Person.all.each do |person|
      PersonUpdater.new(person).update
    end
  end
end