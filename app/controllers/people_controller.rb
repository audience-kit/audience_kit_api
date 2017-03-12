class PeopleController < ApplicationController
  def index
    @people  = HotMessModels::Person.where(global: true)
    @people += HotMessModels::PersonLocale.where(locale_id: params[:locale_id]).map { |pl| pl.person }
    @people  = @people.sort_by { |p| p.order }
  end

  def show
    @person = HotMessModels::Person.find params[:id]
  end

  def picture
    redirect_to "https://facebook.com/#{Person.find(params[:id]).facebook_id}/picture"
  end
end