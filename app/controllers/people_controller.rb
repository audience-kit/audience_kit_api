class PeopleController < ApplicationController
  def index
    @people = (Locale.find(params[:locale_id]).people + Person.where(locale_id: nil)).sort_by { |p| p.order }
  end

  def show
    @person = Person.find params[:id]
  end

  def picture
    redirect_to "https://facebook.com/#{Person.find(params[:id]).facebook_id}/picture"
  end
end