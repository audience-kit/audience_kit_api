class UpdatePeopleJob < ApplicationJob
  def perform(now = false)
    HotMessModels::Person.all.each do |person|
      if now
        UpdatePersonJob.perform_now person
      else
        UpdatePersonJob.perform_later person
      end
    end
  end
end