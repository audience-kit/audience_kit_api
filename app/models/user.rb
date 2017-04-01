class User < ApplicationRecord
  validates_presence_of :facebook_id

  has_many :sessions
  has_many :user_locations
  has_many :venue_messages
  has_many :user_likes
  has_many :tribe_users
  belongs_to :photo
  has_many :rsvps, class_name: 'UserRSVP'

  def update_from(graph)
    self.name          ||= graph['name']
    self.email_address ||= graph['email']
    self.culture       ||= graph['locale']
    self.first_name    ||= graph['first_name']
    self.last_name     ||= graph['last_name']
    self.gender        ||= graph['gender']

    self.facebook_graph = graph
  end

  def self.from_facebook_graph(graph, token = nil)
    ActiveRecord::Base.transaction do
      @user = User.find_or_create_by facebook_id: graph['id'].to_i do |u|
        u.facebook_token = token
        u.facebook_token_issued_at  = DateTime.now
      end
    end

    if token
      @user.facebook_token            = token
      @user.facebook_token_issued_at  = DateTime.now
    end

    @user.update_from graph

    @user.save

    @user
  end
end
