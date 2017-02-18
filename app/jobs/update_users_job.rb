class UpdateUsersJob < ApplicationJob

  def perform
    users = User.where.not(facebook_token: nil)

    users.each do |user|
      graph = Koala::Facebook::API.new user.facebook_token

      user.update_from graph.get_object '/me'
    end
  end
end