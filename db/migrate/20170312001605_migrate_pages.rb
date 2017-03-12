class MigratePages < ActiveRecord::Migration[5.0]
  def change
    # Drop tables with bad schemas that are empty
    drop_table :venue_mapping
    drop_table :person_locales

    # Support clean column layout on people
    [ :order, :requires_like ].each { |c| remove_column :people, c }

    # Prepare by removing any venues without a Facebook page (these are noted in TASKS.md)
    execute 'DELETE FROM events WHERE venue_id IN (SELECT id FROM venues WHERE facebook_id IS NULL)'
    execute 'DELETE FROM venues WHERE facebook_id IS NULL'

    # Create new page aggregate
    create_table :pages, id: :uuid do |t|
      t.timestamps
      t.string    :name, null: false
      t.string    :name_override, null: true, default: nil
      t.bigint    :facebook_id, null: false
      t.jsonb     :facebook_graph, null: false
      t.string    :facebook_access_token, null: true
      t.string    :facets, array: true
    end
    add_index :pages, :facebook_id, unique: true

    # Prepare to_many mapping for venues
    create_table :venue_pages, id: :uuid do |t|
      t.timestamps
      t.references :venue, type: :uuid, null: false
      t.references :page, type: :uuid, null: false
      t.integer    :order, null: false, default: 1000
    end
    add_index :venue_pages, :page_id, name: 'venue_pages_by_page_id'
    add_index :venue_pages, :venue_id, name: 'venue_pages_by_venue_id'
    add_index :venue_pages, [ :page_id, :venue_id, :order ], unique: true, name: 'venue_pages_unique_key'

    # Create person locale mapping table
    create_table :person_locales, id: :uuid do |t|
      t.references :person, type: :uuid, null: false, index: true
      t.references :locale, type: :uuid, null: false, index: true
    end
    add_index :person_locales, [ :person_id, :locale_id ], unique: true, name: 'person_locale_unique_key'

    # Bring columns over from people
    execute 'INSERT INTO pages SELECT uuid_generate_v4(), created_at, updated_at, name, name_override, facebook_id, facebook_graph FROM people'
    add_column :people, :page_id, :uuid
    execute 'UPDATE people SET page_id = (SELECT id FROM pages WHERE pages.facebook_id = people.facebook_id)'
    change_column_null :people, :page_id, false
    add_index :people, :page_id, unique: true

    # Bring columns over from venues
    execute 'INSERT INTO pages SELECT uuid_generate_v4(), created_at, updated_at, name, name_override, facebook_id, facebook_graph FROM venues WHERE facebook_id NOT IN (SELECT facebook_id FROM pages)'
    execute 'INSERT INTO venue_pages SELECT uuid_generate_v4(), created_at, updated_at, venues.id, (SELECT id FROM pages WHERE pages.facebook_id = venues.facebook_id) as page_id, 1000 as order FROM venues'

    # Add order, global flag and requires like to people
    add_column :people, :order, :integer, default: 1000, null: false
    add_column :people, :global, :boolean, default: false, null: false
    add_column :people, :like_required, :boolean, default: false, null: false

    # Move existing locale mappings to supporting relation
    execute 'INSERT INTO person_locales SELECT uuid_generate_v4(), people.id, people.locale_id FROM people WHERE locale_id IS NOT NULL'

    # Perform cleanup by removing duplicate columns
    [ :sound_cloud, :twitter, :instagram, :venue_id, :featured, :facebook_token, :locale_id ].each { |c| remove_column :people, c }
    [ :venues, :people ].each { |t|  [ :created_at, :updated_at, :name, :name_override, :facebook_id, :facebook_graph, :facebook_updated_at ].each { |c| remove_column t, c } }
  end
end
