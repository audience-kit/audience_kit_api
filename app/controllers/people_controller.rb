class PeopleController < ApplicationController
  def index
    @people = Locale.find(params[:locale_id]).people
  end
end