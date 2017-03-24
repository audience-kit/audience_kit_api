class PeopleController < ApplicationController
  include Concerns::PageController

  skip_before_action :authenticate, only: [ :picture, :cover ]

  def index
    @people  = HotMessModels::Person.includes(:page).where(global: true)
    @people += HotMessModels::PersonLocale.includes(person: :page).where(locale_id: params[:locale_id]).map { |pl| pl.person }
    @people  = @people.uniq.sort_by { |p| p.order }

    @user_likes = user.user_likes.to_a.map { |ul| [ ul.page, ul ] }.to_h

    @people = @people.select { |p| p.like_required == false || @user_likes.key?(p) }
  end

  def show
    @person = HotMessModels::Person.find params[:id]

    @is_liked = HotMessModels::UserLike.find_by(user: user, page: @person.page) ? true : false
  end

  def picture
    response.headers["Expires"] = 1.day.from_now.httpdate
    page_image(HotMessModels::Person.find(params[:id]).page)
  end

  def cover
    response.headers["Expires"] = 1.day.from_now.httpdate
    page_image(HotMessModels::Person.find(params[:id]).page, :cover)
  end
end