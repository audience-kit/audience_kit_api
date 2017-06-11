module Admin
  class PeopleController < AdminController
    def index
      people = Person.all.join(:page).map do |person|
        person.attributes.reverse_merge(person.page.attributes)
      end

      render json: people
    end

    def show
      render json: People.find(params[:id])
    end

    def create
      page = Page.page_for_facebook_id current_user.facebook_token, params[:facebook_id]

      page.person ||= Person.new

      person.save

      render json: person
    end

    def update

    end

    def destroy

    end
  end
end