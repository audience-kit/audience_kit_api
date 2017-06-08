module Admin
  class PeopleController < AdminController
    def index
      people = Person.all.map do |person|
        person.attributes.reverse_merge(person.page.attributes)
      end

      render json: people
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