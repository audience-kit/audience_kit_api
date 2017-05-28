module Admin
  class VenuesController < AdminController
    def index
      all_venues = Locale.find(params[:locale_id]).venues.includes(:page, :location, :events)
      venues = all_venues.map do |venue|
        venue.attributes.merge({
                                   display_name: venue.page.display_name,
                                   facebook_id: venue.page&.facebook_id,
                                   google_place_id: venue.location&.google_place_id,
                                   event_count: venue.events.count
                               })
      end
      render json: venues
    end

    def show
      render json: Venue.find(params[:id])
    end

    def create

    end

    def update

    end

    def destroy

    end
  end
end