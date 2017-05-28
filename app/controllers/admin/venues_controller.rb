module Admin
  class VenuesController < AdminController
    def index
      render json: Locale.find(params[:locale_id]).venues
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