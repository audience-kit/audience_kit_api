class PeopleController < ApplicationController
  include Concerns::PageController

  skip_before_action :authenticate, only: [ :picture, :cover ]

  def index
    @people  = Person.includes(:page).where(global: true)
    @people += PersonLocale.includes(person: :page).where(locale_id: params[:locale_id]).map { |pl| pl.person }
    @people  = @people.uniq.sort_by { |p| p.order }

    @user_likes = current_user.user_likes.to_a.map { |ul| [ ul.page, ul ] }.to_h

    @people = @people.select { |p| p.like_required == false || @user_likes.key?(p.page) }
  end

  def show
    @person = Person.find params[:id]

    @is_liked = UserLike.find_by(user: current_user, page: @person.page) ? true : false

    kinesis :person_view, @person.id, id: @person.id, user_id: current_user.id, is_liked: @is_liked
  end

  def picture
    page_image(Person.find(params[:id]).page)
  end

  def cover
    page_image(Person.find(params[:id]).page, :cover)
  end

  def events
    @person = Person.find params[:id]

    @events = @person.events

    render 'events/index'
  end
end