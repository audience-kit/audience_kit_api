class PeopleController < ApplicationController
  include Concerns::PageController

  def index
    @people  = HotMessModels::Person.includes(:page).where(global: true)
    @people += HotMessModels::PersonLocale.includes(person: :page).where(locale_id: params[:locale_id]).map { |pl| pl.person }
    @people  = @people.sort_by { |p| p.order }
  end

  def show
    @person = HotMessModels::Person.find params[:id]
  end

  def picture
    page_image(HotMessModels::Person.find(params[:id]).page)
  end

  def cover
    page_image(HotMessModels::Person.find(params[:id]).page, :cover)
  end
end