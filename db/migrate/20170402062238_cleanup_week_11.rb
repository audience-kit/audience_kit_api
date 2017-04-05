# frozen_string_literal: true

class CleanupWeek11 < ActiveRecord::Migration[5.0]
  def change
    remove_column :locations, :locale_id

    remove_column :tracks, :artwork_url
    remove_column :tracks, :artwork_image

    remove_column :tracks, :waveform_url
    remove_column :tracks, :waveform_image

    drop_table :venue_pages
  end
end
