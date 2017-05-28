module Admin
  class PeopleController < AdminController
    def index
      render json: Locale.find(params[:locale_id]).people
    end

    def show
      render json: People.find(params[:id])
    end

    def create

    end

    def update

    end

    def destroy

    end
  end
end