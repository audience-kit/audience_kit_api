module Admin
  class LocalesController < AdminController
    def index
      locales = Locale.all.includes(:venues).map do |locale|
        locale.attributes.merge venue_count: locale.venues.where(hidden: false).count,
            hidden_venue_count: locale.venues.where(hidden: true).count
      end
      render json: locales
    end

    def show
      render json: Locale.find(params[:id])
    end

    def create

    end

    def update

    end

    def destroy

    end
  end
end