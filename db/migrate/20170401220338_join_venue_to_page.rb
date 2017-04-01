class JoinVenueToPage < ActiveRecord::Migration[5.0]
  def change
    add_reference :venues, :page, type: :uuid, foreign_key: true

    CSV.foreach(Rails.root.join('db/venue_pages.csv')) do |row|
      venue_id = row[3]
      page_id = row[4]

      venue = Venue.find(venue_id)
      venue.page = Page.find(page_id)

      venue.save
    end
  end
end
