class UsersController < ApplicationController
  def me
    render json: { id: @user.id }
  end
end