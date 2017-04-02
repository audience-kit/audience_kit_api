class Page < ApplicationRecord
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


    if options[:client]
      image_data = options[:client].get_picture_data(graph['id'], type: :large)['data']
      image_url = image_data['url']

      self.photo = Photo.for_url image_url
    end
  end
end
