# frozen_string_literal: true

class Photo < ApplicationRecord
  validates_presence_of :content_hash, :content, :mime, :source_url

  S3_BUCKET_NAME = 'prodhotmessuswest'

  def self.for_url(url)
    photo = Photo.find_by(source_url: url)

    unless photo
      response = Net::HTTP.get_response(URI(url))
      data = response.body
      hash = Digest::SHA1.new.digest data

      client = Aws::S3::Client.new region: 'us-west-2', credentials: AWS_CREDENTIALS

      hash_url_safe = Base64.urlsafe_encode64 hash, padding: false

      client.put_object(bucket: S3_BUCKET_NAME,
                        key: "public/#{hash_url_safe}",
                        body: data,
                        content_type: mime,
                        acl: 'public-read',
                        metadata: {
                          original_url: self.source_url,
                        })

      photo = Photo.find_or_create_by(content_hash: hash) do |p|
        p.content_hash = hash
        p.mime = response['Content-Type']
        p.source_url = url
        p.cdn_url = "https://cdn.hotmess.social/#{hash_url_safe}"
      end

      photo.mime = response['Content-Type']
      photo.source_url = url
      photo.cdn_url = stored_url

      photo.save
    end

    photo
  end

  def update
    hash_url_safe = Base64.urlsafe_encode64 content_hash, padding: false
    self.cdn_url = "https://cdn.hotmess.social/#{hash_url_safe}"

    save
  end
end
