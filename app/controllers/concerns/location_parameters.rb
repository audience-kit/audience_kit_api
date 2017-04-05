# frozen_string_literal: true

module Concerns
  module LocationParameters
    extend ActiveSupport::Concern

    included do
      def location_param
        @latitude = params.require :latitude
        @longitude = params.require :longitude

        @point = RGeo::Geographic.simple_mercator_factory.point @longitude, @latitude
      end
    end
  end
end
