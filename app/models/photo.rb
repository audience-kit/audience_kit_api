class Photo < ApplicationRecord
  validates_presence_of :content_hash, :content, :mime, :source_url

  def self.for_url(url)
    photo = Photo.find_by(source_url: url)

    unless photo
      response =  Net::HTTP.get_response(URI(url))
      data = response.body
      hash = Digest::SHA1.new.digest data

      photo = Photo.find_or_create_by(content_hash: hash) do |p|
        p.content_hash = hash
        p.mime = response['Content-Type']
        p.content = data
        p.source_url = url
      end

      photo.mime = response['Content-Type']
      photo.content = data
      photo.source_url = url
    end

    photo
  end
end
