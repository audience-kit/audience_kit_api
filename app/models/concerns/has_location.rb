module Concerns
  module HasLocation
    extend ActiveSupport::Concern

    included do

      def update_location(longitude, latitude)
        self.location = RGeo::Geographic.simple_mercator_factory.point longitude, latitude
      end

      def update_location_geocode(street, zip)
        return if self.google_place_id or street == nil or zip == nil

        location = "#{street}, #{zip}, USA"
        puts "Geocoding => #{location}"

        spot = Geocoder.coordinates location

        self.update_location spot[0], spot[1] if spot
        #self.google_place_id = spot['place_id']
        self.google_location = spot
      end
    end
  end
end