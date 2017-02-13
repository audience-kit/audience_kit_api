# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
config = YAML.load_file("#{Rails.root.to_s}/config/seeds.yml").with_indifferent_access

config[:locales].each do |locale_info|
  locale = Locale.find_or_initialize_by(label: locale_info[:label])
  locale.name = locale_info[:name]
  locale.google_place_id = locale_info[:google_place_id]
  locale.beacon_major = locale_info[:beacon_major]
  locale.save

  (locale_info[:venues] || []).map {|v| v.with_indifferent_access}.each do |venue_info|
    begin
      venue = locale.venues.find_or_initialize_by(google_place_id: venue_info[:google_place_id])

      venue.name = venue_info[:name]
      venue.facebook_id = venue_info[:facebook_id]
      venue.hidden = false

      if venue_info[:beacon_minors]
        venue.beacon_id = venue_info[:beacon_minors].first
      end

      venue.save
    rescue => ex
      puts ex
    end
  end

  (locale_info[:people] || []).each do |person_id|
    begin
      person = locale.people.find_or_initialize_by(facebook_id: person_id)
      person.requires_like = false
      person.save

      puts "Upsert Person => #{person_id}"
    rescue => ex
      puts ex
    end
  end

end