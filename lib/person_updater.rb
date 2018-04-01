class PersonUpdater < PageUpdater
  def initialize(person)
    super person.page

    @person = person
  end

  to_update do
    username = @page.facebook_graph['username']
    if username
      @page.person.social_links.find_or_create_by(provider: 'facebook', handle: username)
    end

    if @page.facebook_graph['cover']
      @page.cover_photo = Photo.for_url @page.facebook_graph['cover']['source']
    end
  end

  on_event do |event|
    event.people.find_or_initialize_by(person: @person, role: 'host')
  end
end