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
      locale = Locale.find(params[:locale_id])

      page = Page.page_for_facebook_id current_user.facebook_token, params[:facebook_id]

      venue = locale.venues.build page: page

      place = Location.from_google_place_id params[:google_place_id]

      venue.location = place

      venue.save!

      render json: venue
    end

    def update

    end

    def destroy

    end

    def missing_google
      @venues = Venue.joins(:page).where('location_id IS NULL').map do |venue|
        venue.attributes.reverse_merge venue.page.attributes
      end

      render json: @venues
    end
  end
end