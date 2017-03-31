class VenueRefactor < ActiveRecord::Migration[5.0]
  def change
    add_reference :venues, :page, type: :uuid, foreign_key: true

    add_column :venues, :alternate_facebook_ids, :string, array: true

    add_column :photos, :cdn_url, :string

    execute 'UPDATE venues SET page_id = (SELECT page_id FROM venue_pages WHERE venue_id = venues.id LIMIT 1)'

    drop_table :venue_pages
  end
end
