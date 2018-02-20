# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'resque/tasks'

task 'resque:setup' => :environment

desc 'Update data models'
task update: :environment do
  UpdateJob.perform_now(true)
end

namespace :update do
  desc 'Update all Facebook page objects'
  task pages: :environment do
    UpdatePagesJob.perform_now
  end

  desc 'Update google place data'
  task locations: :environment do
    UpdateGooglePlaceJob.perform_now
  end

  desc 'Update events'
  task events: :environment do
    Event.all.each(&:update_details_from_facebook)
  end

  desc 'Update users'
  task users: :environment do
    UpdateUsersJob.perform_now
  end

  desc 'Update envelopes'
  task envelopes: :environment do
    UpdateEnvelopeJob.perform_now
  end

  desc 'Update social links'
  task social: :environment do
    UpdateSocialLinksJob.perform_now
  end

  desc 'Update users'
  task users: :environment do
    UpdateUsersJob.perform_now
  end

  desc 'Update ticket types'
  task tickets: :environment do
    Event.all.each(&:update_tickets)
  end
end


namespace :repair do
  namespace :images do
    desc 'Repair image mime types'
    task :mime => :environment do
      client = Azure::Storage::Blob::BlobService.create(storage_account_name: 'audiencekitcdn',
                                                        storage_access_key: Rails.application.secrets[:cdn_storage_key])

      Photo.all.each do |photo|
        hash_url_safe = Base64.urlsafe_encode64 photo.content_hash, padding: false

        begin
          blob = client.get_blob_properties 'photos', "#{hash_url_safe}"

          if blob
            client.set_blob_properties 'photos', "#{hash_url_safe}", content_type: photo.mime
          end
        rescue Azure::Core::Http::HTTPError
          puts "Skipping for #{hash_url_safe} as the blob does not exit"
          next
        end
      end
    end
  end
end