# frozen_string_literal: true

class Page < ApplicationRecord
  PAGE_FIELDS = %w[name cover location]


  validates_presence_of :name, :facebook_id, :facebook_graph
  validates_presence_of :name_override, allow_nil: true

  has_one :venue
  has_one :person

  belongs_to :photo
  belongs_to :cover_photo, class_name: 'Photo'

  has_many :reviews

  has_and_belongs_to_many :users, join_table: 'user_likes'

  has_many :events, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }

  def display_name
    name_override || name
  end

  def update_graph(graph, options = {})
    self.facebook_graph = graph
    self.name = graph['name']

    if graph['cover']
      cover_url = graph['cover']['source']

      self.cover_photo = Photo.for_url cover_url
    end

    if options[:photo]
      image_url = options[:photo]['url']

      self.photo = Photo.for_url image_url
    end
  end

  def self.page_for_facebook_id(token, facebook_id, hidden = false)
    page = find_by(facebook_id: facebook_id)

    return page if page

    client = Koala::Facebook::API.new token

    graph = client.get_object facebook_id, fields: PAGE_FIELDS
    page = Page.new(facebook_id: facebook_id, hidden: hidden)
    page.facebook_graph = graph
    page.name = graph['name']
    photo_data = client.get_picture_data(page.facebook_id, type: :large)['data']

    page.update_graph graph, photo: photo_data

    page.save

    page
  end
end
