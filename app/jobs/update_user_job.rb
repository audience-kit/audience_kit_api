class UpdateUserJob < ApplicationJob
  def perform(user)
    puts "Updating user #{user.name}"
    begin
      begin
        graph_client = Koala::Facebook::API.new user.facebook_token

        user_graph = graph_client.get_object user.facebook_id
      rescue Koala::Facebook::OAuthTokenRequestError => ex
        user.facebook_token = nil
        user.save
      end

      image_data = graph_client.get_picture_data(user.facebook_id, type: :large)['data']

      photo = Photo.for_url image_data['url']

      user.photo = photo

      scopes = graph_client.get_connections :me, :permissions
      user.facebook_scopes = scopes.select{ |s| s['status'] == 'granted' }.map { |s| s['permission'] }

      update_user_pages(user) if user.facebook_scopes.include? 'manage_pages'

      user.update_from user_graph
      user.save

      self.update_likes user, graph_client
      self.update_friends user, graph_client
      self.update_events user, graph_client

    rescue => ex
      puts "Error updating #{user.name} => #{ex}"
    end
  end

  def update_user_pages(user)
    graph = Koala::Facebook::API.new user.facebook_token

    accounts = graph.get_connections('me', 'accounts')

    accounts.each do |account|
      page = Page.find_by(facebook_id: account['id'].to_i)

      if page
        user_page = UserPage.find_or_initialize_by(user: user, page: page)

        user_page.facebook_token = account['access_token']
        user_page.save!
      end
    end
  end

  # TODO: NOT FUNCTIONAL PARADIGM
  def update_events(user, user_graph_client)
    events = user_graph_client.get_connection :me, :events

    event_rsvps = []

    while events
      events.each do |event|
        event_rsvps << { facebook_id: event[:id], rsvp: event[:rsvp_status] }
      end

      events = events.next_page
    end

    event_table = Event.where(facebook_id: event_rsvps.map { |e| e[:facebook_id] }).to_h {|e| e.facebook_id }

    event_rsvps.each do |rsvp|
      rsvp[:event] = event_table[rsvp[:facebook_id].to_i]
    end

    event_rsvps.each do |rsvp|
      next unless rsvp[:event]

      rsvp[:model] = user.rsvps.find_or_create_by(event: rsvp[:event]) do |rsvp|
        rsvp.state = rsvp[:rsvp_status]
      end

      rsvp[:model].state = rsvp[:rsvp_status]
    end
  end

  def update_likes(user, user_graph_client)
    return
    # This will be additive only, should remove
    puts 'Inserting user likes'
    user_likes = user_graph_client.get_connections :me, :likes
    existing_user_likes = user.user_likes.includes(:page)

    while user_likes
      user_likes.each do |like|
        page = Page.find_by(facebook_id: like['id'])

        unless page
          page = Page.find_or_create_by(facebook_id: like['id']) do |p|
            p.hidden = true
            page_graph = user_graph_client.get_object like['id']
            p.name = page_graph['name']
            p.facebook_graph = page_graph
          end
        end

        puts "Adding like for page #{page.name}"
        user.user_likes.find_or_create_by(user: user, page: page)
      end
      user_likes = user_likes.next_page
    end
  end

  def update_friends(user, user_graph_client)

    friends = []
    friend_pages = user_graph_client.get_connections(user.facebook_id, :friends)
    while friend_pages
      friend_pages.each { |f| friends << f }
      friend_pages = friend_pages.next_page
    end

    puts "Object #{user.name} has #{friends.count} application friends"
    friends.each do |friend|
      friend_id = friend['id'].to_i

      pair = [ user.facebook_id, friend_id ].sort
      pair_hash = pair.join('_')

      friend_object = user_graph_client.get_object friend_id

      friend_user = User.find_or_create_by facebook_id: friend_object['id']
      friend_user.update_from friend_object

      friend_user.save

      friendship = Friendship.find_or_initialize_by(friend_hash: pair_hash)

      friendship.friend_low_id = User.find_by(facebook_id: pair[0]).id
      friendship.friend_high_id = User.find_by(facebook_id: pair[1]).id
      friendship.save

      FriendshipLink.find_or_create_by(user: user, friend: friend_user, friendship: friendship)
      FriendshipLink.find_or_create_by(user: friend_user, friend: user, friendship: friendship)
    end
  end
end
