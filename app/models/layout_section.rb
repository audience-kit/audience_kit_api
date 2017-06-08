class LayoutSection
  attr_accessor :title
  attr_accessor :items

  def initialize(title)
    @title = title

    @items = []
  end
end