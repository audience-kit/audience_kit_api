module Admin
  class AdminController < ApplicationController
    before_action :require_admin

    def require_admin
      render status: :unauthorized unless admin?
    end
  end
end