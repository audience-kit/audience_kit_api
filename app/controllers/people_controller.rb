class PeopleController < ApplicatonController
  def index
    @people = Person.all
  end
end