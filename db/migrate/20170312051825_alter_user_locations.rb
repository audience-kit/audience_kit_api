class AlterUserLocations < ActiveRecord::Migration[5.0]
  def change
    # Remove all data from table
    execute 'TRUNCATE TABLE user_locations'

    # Relation user_location to session, this will help establish if reporting is background or user generated
    #  and location which represents the closest location (this allows for measuring distance to locale and envelope accuracy)
    add_reference :user_locations, :session, type: :uuid, null: false
    add_reference :user_locations, :location, type: :uuid, null: false

    # Track only if the location fix was from beacon
    add_column :user_locations, :beacon, :boolean

    # Remove ambiguity between location and postgis point
    rename_column :user_locations, :location, :point

    # Remove columns for user_id (location will be done near release as the data will help improve envelopes)
    [ :user_id, :beacon_minor, :locale_id ].each { |c| remove_column :user_locations, c }
  end
end
