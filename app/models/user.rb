class User < ApplicationRecord
  has_many :sessions

  def update_from(graph)
    self.name          = graph['name']
    self.email_address = graph['email']
    self.culture       = graph['locale']
    self.first_name    = graph['first_name']
    self.last_name     = graph['last_name']
    self.gender        = graph['gender']

    self.facebook_graph = graph
  end
end
