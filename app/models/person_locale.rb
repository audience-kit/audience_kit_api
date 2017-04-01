class PersonLocale < ApplicationRecord
  belongs_to :locale
  belongs_to :person
end
