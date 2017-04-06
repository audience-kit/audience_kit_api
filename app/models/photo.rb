# frozen_string_literal: true

class Photo < ApplicationRecord
  validates_presence_of :content_hash, :mime, :source_url, :cdn_url

  S3_BUCKET_NAME = 'prodhotmessuswest'

  def self.for_url(url)
    photo = Photo.find_by(source_url: url)

    unless photo
      response = Net::HTTP.get_response(URI(url))
      hash = Digest::SHA1.new.digest response.body
      hash_url_safe = Base64.urlsafe_encode64 hash, padding: false

      photo = Photo.find_or_create_by(content_hash: hash) do |p|
        p.mime = response['Content-Type']
        p.source_url = url
        p.cdn_url = "https://cdn.hotmess.social/#{hash_url_safe}"
      end

      photo.store(hash_url_safe, response.body)
    end

    photo
  end

  def store(name, data)
    client = Aws::S3::Client.new region: 'us-west-2', credentials: AWS_CREDENTIALS

    client.put_object(bucket: S3_BUCKET_NAME,
                      key: "public/#{name}",
                      body: data,
                      content_type: mime,
                      acl: 'public-read',
                      metadata: {
                          original_url: source_url,
                      })

  end
end
