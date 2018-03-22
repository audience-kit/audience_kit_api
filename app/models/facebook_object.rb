class FacebookObject
  include Mongoid::Document

  field :path, type: String
  field :fetched_at, type: DateTime
  field :fetched_by, type: String
  field :document, type: Hash
end