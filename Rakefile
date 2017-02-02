# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'resque/tasks'

task 'resque:setup' => :environment

namespace :update do
  desc 'Update all Venue objects'
  task :venues => :environment do
    UpdateVenuesJob.perform_now
  end

  desc 'Update google place data'
  task :google => :environment do
    UpdateGooglePlaceJob.perform_now
  end

  desc 'Update events'
  task :events => :environment do
    Event.all.each do |event|
      event.start_at  = event.facebook_graph['start_time']
      event.end_at    = event.facebook_graph['end_time']

      event.save
    end
  end
end