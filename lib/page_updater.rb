class PageUpdater
  EVENT_FIELDS = %w[ticket_uri owner name cover start_time end_time place is_canceled].freeze
  PAGE_FIELDS = %w[name cover category category_list instagram_accounts place_topics ratings screennames location]

  cattr_reader :updater, :on_event

  def self.to_update(&block)
    @updater = block
  end

  def self.on_event(&block)
    @on_event = block
  end

  def initialize(page)
    @page = page

    @client = Koala::Facebook::API.new User.find_by_email_address('rickmark@outlook.com').facebook_token
  end

  def update
    return if @page.last_update_error.nil? and  @page.updated_at > 12.hours.ago

    update_page do
      Rails.logger.info "Updating #{@page.name} (#{@page.facebook_id})"
      self.class.updater if self.class.updater
      update_photo_and_self
      update_events
    end
  end

  protected
  def update_page
    begin
      yield
      @page.last_update_error = nil
    rescue => ex
      @page.last_update_error = ex
      Rails.logger.error "Error updating #{@page.name} (#{@page.facebook_id}) => #{ex}"
    end
    @page.save
  end

  private
  def update_photo_and_self
    begin
      photo = @client.get_picture_data(@page.facebook_id, type: :large)['data']
      puts "Got photo for object"
      @page.update_photo photo

      object = @client.get_object @page.facebook_id, fields: PAGE_FIELDS
      puts "Got data for object"

      @page.update_graph object
    rescue => ex
      @page.last_update_error = ex
    end
    @page.save
  end

  def update_events
    events = @client.get_connection( @page.facebook_id, :events)

    while events
      events.select { |e| e['start_time'] && DateTime.parse(e['start_time']) > DateTime.now }.each do |event|
        begin
          update_event event
        rescue => ex
          Rails.logger.warn "Failure in updaing event #{event} => #{ex}"
        end
      end
      events = events.next_page
    end
  end

  def update_event(event)
    model = Event.find_or_initialize_by facebook_id: event['id']

    graph = @client.get_object event['id'], fields: EVENT_FIELDS
    model.facebook_graph = graph

    if graph['cover']
      model.cover_photo = Photo.for_url graph['cover']['source']
    end

    model.save

    if graph['place']
      venue_id = graph['place']['id']

      venue_page = Page.page_for_facebook_id(venue_id, true)

      model.venue = venue_page.venue || Venue.new(hidden: true, page: venue_page) if venue_page
    elsif graph['owner']
      page = Page.find_by(facebook_id: graph['owner']['id'])

      model.venue = page.venue
    else
      logger.warn "No venue for #{graph['name']} (#{event_graph['id']})"
    end



    model.update_details_from_facebook if model.venue

    model.update_tickets

    self.class.on_event if self.class.on_event
  end
end