module Admin
  class LocalesController < AdminController
    def index
      render json: Locale.all
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