# frozen_string_literal: true

class EventCoverPhoto < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :cover_photo, type: :uuid, foreign_key: { to_table: :photos }
  end
end
