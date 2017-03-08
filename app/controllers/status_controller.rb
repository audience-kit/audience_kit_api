class StatusController < ApplicationController
  skip_before_action :authenticate

  def index
    result = {}

    # Test database connectivity and that there is data
    begin
      result[:database] = false

      if HotMessModels::Venue.any?
        result[:database] = true
      end
    rescue
      result[:database] = false
    end

    render json: result
  end
end
