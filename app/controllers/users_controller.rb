class UsersController < ApplicationController
  def me
      # TODO: This exposes things not meant for the user to ever see
      UpdateUserJob.perform_later @user

     render json: @user
  end
end