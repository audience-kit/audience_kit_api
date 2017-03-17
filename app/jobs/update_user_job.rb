class UpdateUserJob < ApplicationJob
  def perform(user)
    puts "Updating user #{user.name}"
    begin
      graph = Koala::Facebook::API.new Concerns::Facebook.oauth.get_app_access_token

      user_graph = graph.get_object user.facebook_id

      image_data = graph.get_picture_data(user.facebook_id, type: :large)['data']
      image_url = image_data['url']

      unless user.picture_url == image_url
        puts "Updating profile image for #{user.name}"
        user.picture_url = image_url
        response =  Net::HTTP.get_response(URI(user.picture_url))
        user.picture_image = response.body
        user.picture_mime = response['Content-Type']
      end

      user.update_from user_graph
      user.save

      user_graph_client = Koala::Facebook::API.new user.facebook_token

      friends = user_graph_client.get_connections(user.facebook_id, :friends)
      puts "Object #{user.name} has #{friends.count} application friends"
      friends.each do |friend|
        friend_id = friend['id'].to_i

        pair = [ user.facebook_id, friend_id ].sort
        pair_hash = pair.join('_')

        friend_object = graph.get_object friend_id

        friend_user = HotMessModels::User.find_or_create_by facebook_id: friend_object['id']
        friend_user.update_from friend_object

        friend_user.save

        friendship = HotMessModels::Friendship.find_or_initialize_by(friend_hash: pair_hash)

        friendship.friend_low_id = HotMessModels::User.find_by(facebook_id: pair[0]).id
        friendship.friend_high_id = HotMessModels::User.find_by(facebook_id: pair[1]).id
        friendship.save

      end
    rescue => ex
      puts "Error updating #{user.name} => #{ex}"
    end
  end
end
