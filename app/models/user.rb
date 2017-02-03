class User < ApplicationRecord
  has_many :sessions
  has_many :user_locations

  def update_from(graph)
    self.name          = graph['name']
    self.email_address = graph['email']
    self.culture       = graph['locale']
    self.first_name    = graph['first_name']
    self.last_name     = graph['last_name']
    self.gender        = graph['gender']

    self.facebook_graph = graph
  end

  def self.from_facebook_graph(graph)
    @user = User.find_or_initialize_by facebook_id: graph['id'].to_i

    @user.update_from graph

    @user
  end
end
