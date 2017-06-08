class LayoutItem
  include ActiveModel::Model

  attr_accessor :id
  attr_accessor :type
  attr_accessor :title
  attr_accessor :description
  attr_accessor :height
  attr_accessor :photo_url
  attr_accessor :link_url
  attr_accessor :distance
  attr_accessor :start_at

  def initialize(type)
    @type = type
  end
end