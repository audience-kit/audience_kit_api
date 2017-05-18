# frozen_string_literal: true

class StatusController < ApplicationController
  skip_before_action :authenticate

  def index
    if params[:device]
      @device = Device.from_identifier params['device']['identifier'], type: params['device']['type']

      @device.model ||= params['device']['model']

      @device.save
    end

    result = {}

    # Test database connectivity and that there is data
    begin
      result[:database] = false

      if Venue.any?
        result[:database] = true
      end
    rescue
      result[:database] = false
    end

    result[:client] = YAML.load_file(Rails.root.join('config/clients.yml'))

    render json: result
  end
end
