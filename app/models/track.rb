# frozen_string_literal: true

class Track < ApplicationRecord
  belongs_to :social_link
  belongs_to :photo
  belongs_to :waveform_photo, class_name: 'Photo'
end
