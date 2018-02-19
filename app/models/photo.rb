# frozen_string_literal: true

require 'azure/storage/blob'

class Photo < ApplicationRecord
  validates_presence_of :content_hash, :mime, :source_url, :cdn_url

  AZURE_STORAGE_NAME = 'audiencekitcdn'

  def self.for_url(url)
    photo = Photo.find_by(source_url: url)

    unless photo
      response = Net::HTTP.get_response(URI(url))
      hash = Digest::SHA1.new.digest response.body
      hash_url_safe = Base64.urlsafe_encode64 hash, padding: false

      photo = Photo.find_or_create_by(content_hash: hash) do |p|
        p.mime = response['Content-Type']
        p.source_url = url
        p.cdn_url = "https://audiencekitcdn.blob.core.windows.net/public/public/#{hash_url_safe}"
      end

      photo.store(hash_url_safe, response.body)
    end

    photo
  end

  def store(name, data)
# Setup a specific instance of an Azure::Storage::Blob::BlobService
    client = Azure::Storage::Blob::BlobService.create(storage_account_name: AZURE_STORAGE_NAME,
                                                           storage_access_key: Rails.application.secrets[:cdn_storage_key])

    client.create_block_blob('public', "public/#{name}", data, content_type: mime)
  end

  def store_s3(name, data)
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
