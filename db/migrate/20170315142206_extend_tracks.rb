class ExtendTracks < ActiveRecord::Migration[5.0]
  def change
    execute 'TRUNCATE TABLE tracks'

    add_column :tracks, :artwork_url, :string
    add_column :tracks, :artwork_image, :binary
    add_column :tracks, :waveform_url, :string
    add_column :tracks, :waveform_image, :binary
    add_column :tracks, :download_url, :string
    add_column :tracks, :stream_url, :string
    add_column :tracks, :metadata, :jsonb
  end
end
