class UpdateUsersJob < ApplicationJob

  def perform
    User.where.not(facebook_token: nil).each do |user|
      begin
        UpdateUserJob.perform_now user
      rescue => ex
        puts "Error => #{ex}"
      end
    end
  end
end