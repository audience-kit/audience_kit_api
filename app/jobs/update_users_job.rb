class UpdateUsersJob < ApplicationJob

  def perform
    users = User.where.not(facebook_token: nil).to_a

    users.each do |user|
      UpdateUserJob.perform_now user
    end
  end
end