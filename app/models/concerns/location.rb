module Concerns
  module Location
    extend ActiveSupport::Concern

    included do
      belongs_to :location
      belongs_to :photo

      def display_name
        location.google_location['name']
      end

      def populate_from_google

      end

      def update_location(longitude, latitude)
        puts "Location => #{self.to_s}"
        location.point = RGeo::Geographic.simple_mercator_factory.point longitude, latitude
      end

      def update_location_geocode(street, zip)
        return if location.google_place_id or street == nil or zip == nil

        location = "#{street}, #{zip}, USA"
        puts "Geocoding => #{location}"

        spot = Geocoder.coordinates location

        location.update_location spot[0], spot[1] if spot
        #self.google_place_id = spot['place_id']
        location.google_location = spot
      end
    end

    class_methods do
      def closest(point, options = {})
        if options[:within]
          return joins(:location).where("ST_Within(ST_GeomFromText('#{point.as_text}')::geography::geometry, locations.envelope::geometry)").order("st_distance(locations.point, '#{point.as_text}')").first
        end

        joins(:location).order("st_distance(locations.point, '#{point.as_text}')").first
      end
    end
  end
end