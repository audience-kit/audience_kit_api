class Event < ApplicationRecord
  EVENT_FIELDS = %w[ticket_uri owner name cover start_time end_time place is_canceled].freeze


  EVYY_URI = /ticketmaster\.evyy\.net/
  TICKETMASTER_URI = /.+ticketmaster\.com\/event\/([0-9A-F]+)(\?.+)?/.freeze
  EVENTBRITE_URI = /.+eventbrite\.com\/e\/.+\-(\d+)\??.*/.freeze

  validates_presence_of :name

  belongs_to :venue
  has_many :event_people
  has_many :ticket_types
  has_many :people, through: :event_people
  has_many :rsvps, class_name: 'UserRSVP'
  belongs_to :cover_photo, class_name: 'Photo'

  delegate :locale, to: :venue

  scope :future, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }

  def update_details_from_facebook
    self.start_at  = self.facebook_graph['start_time']
    self.end_at    = self.facebook_graph['end_time']
    self.name      = self.facebook_graph['name']

    save
  end

  def display_name
    name_override || name
  end

  def person
    first = event_people.first

    first ? first.person : nil
  end

  def update_tickets
    url = facebook_graph['ticket_uri']

    if EVYY_URI.match? url
      parsed_uri = Rack::Utils.parse_query(URI(url).query)
      url = parsed_uri['u']
    end

    case url
    when TICKETMASTER_URI
      update_ticketmaster($~[1])
    when EVENTBRITE_URI
      update_eventbrite($~[1])
    else
      return
    end
  end

  def update_eventbrite(event_id)
    puts "Eventbrite #{event_id}"
    event = Eventbrite::Event.retrieve(event_id)

    ticket_types.find_or_create_by(provider: 'eventbrite', provider_id: event_id)
  end

  def update_ticketmaster(event_id)
    puts "Ticketmaster #{event_id}"
    event = TICKETMASTER_CLIENT.get_event(event_id, version: 'v1')
    puts event.name

    ticket_types.find_or_create_by(provider: 'ticketmaster', provider_id: event_id)
  end

  def to_english
    "starting at <say-as interpret-as='time'>#{start_at.strftime('%H:%M')}</say-as>, #{name} hosted by #{venue.name}"
  end

  def to_layout(featured = false)
    event = LayoutItem.new featured ? :featured_event : :event
    event.id = self.id
    event.title = self.display_name
    event.photo_url = self.cover_photo&.cdn_url
    event.link_url = "https://hotmess.social/events/#{self.id}"
    event.height = 60
    event.start_at = self.start_at

    event
  end
end
