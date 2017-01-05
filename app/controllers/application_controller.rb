class ApplicationController < ActionController::API
  before_action :validate_authentication

  def validate_authentication
    # validate "Authorization: Bearer {JWT}"

  end
end
