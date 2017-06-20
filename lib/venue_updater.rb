class VenueUpdater < PageUpdater
  def initialize(venue)
    super venue.page

    @venue = venue
  end

  to_update do
    @venue.update_data
  end

  on_event do |event|
    event.venue = @venue
  end
end