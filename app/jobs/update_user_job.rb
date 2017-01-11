class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(user)
    graph = Koala::Facebook::API.new Concerns::Facebook.oauth.get_app_access_token

    begin
      user.update_from graph.get_object user.facebook_id

      graph.get_connections(user.facebook_id, :friends).each do |friend|
        friend_object = graph.get_object friend['id']

        friend_user = User.find_or_initialize_by facebook_id: friend_object['id']
        friend_user.update_from friend_object

        friend_user.save
      end
    rescue => ex
      logger.error ex
    end
  end
end
