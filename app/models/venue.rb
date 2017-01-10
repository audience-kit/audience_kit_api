class Venue
  @venues = Venue.load_venues

  class << self
    def all
      @venues.values
    end

    def find(id)
      @venues[id]
    end

    def load_venues
      items = YAML.load_file("#{Rails.root.to_s}/config/seeds.yml")

      items = items.map { |item| Venue.new item }


    end
  end

  def initialize(value)
    @value = value
  end

  def method_missing(name, args)
    @value[name]
  end
end