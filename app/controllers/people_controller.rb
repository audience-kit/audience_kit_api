class PeopleController < ApplicationController
  def index
    @people = Locale.find(params[:locale_id]).people + People.where(locale_id: nil)
  end
end