# frozen_string_literal: true

class Person < ApplicationRecord
  validates_presence_of :page
  belongs_to :page

  has_many :event_people
  has_many :events, -> { where('start_at > ? OR end_at > ?', DateTime.now, DateTime.now).order(start_at: :asc) }, through: :event_people

  delegate :facebook_id, :display_name, :name, :name=, to: :page, allow_nil: true

  def social_links
    SocialLink.where(object_id: id).includes(:tracks)
  end

  def tracks
    social_links.flat_map(&:tracks)
  end
end
