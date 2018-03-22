class FacebookCache
  def self.shared
    @@shared || FacebookCache.new
  end

  def get_object(path, fields)
    graph_client = Koala::Facebook::API.new user.facebook_token

  end
end