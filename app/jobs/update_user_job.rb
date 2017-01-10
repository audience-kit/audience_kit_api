class UpdateUserJob < ApplicationJob
  queue_as :default

  def perform(user)
    graph = Koala::Facebook::API.new Facebook.oauth.get_app_access_token


    logger.info "User => #{user}"

    begin

      logger.info "UserID => #{user.facebook_id}"
      me                  = graph.get_object user.facebook_id
      user.name           = me['name']
      user.email_address  = me['email']

      friends = graph.get_connections user.facebook_id, :friends

      logger.info "Friends => #{friends}"

      friends.each do |friend|
        id = friend["id"]

        friend_object = graph.get_object id

        logger.info "FriendGraph => #{friend_object}"

        friend_user               = User.find_or_initialize_by facebook_id: id.to_i
        friend_user.name          = friend_object["name"]
        friend_user.email_address = friend_object["email"]

        friend_user.save
      end
    rescue => ex
      logger.error ex
    end
  end
end
