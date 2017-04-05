# frozen_string_literal: true

class SocialLink < ApplicationRecord
  has_many :tracks

  def url
    case provider
    when 'soundcloud'
      "https://soundcloud.com/#{handle}"
    when 'facebook'
      "https://facebook.com/#{handle}"
    when 'twitter'
      "https://twitter.com/#{handle}"
    when 'instagram'
      "https://instagram.com/#{handle}"
    else
      nil
    end
  end
end
