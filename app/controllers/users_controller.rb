class UsersController < ApplicationController
  def me
      # TODO: This exposes things not meant for the user to ever see
     render json: @user
  end
end