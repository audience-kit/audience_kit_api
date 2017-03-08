class PeopleController < ApplicationController
  def index
    @people  = HotMessModels::Locale.find(params[:locale_id]).people
    @people += HotMessModels::Person.where(locale_id: nil)
    @people  = @people.sort_by { |p| p.order }
  end

  def show
    @person = HotMessModels::Person.find params[:id]
  end

  def picture
    redirect_to "https://facebook.com/#{Person.find(params[:id]).facebook_id}/picture"
  end
end