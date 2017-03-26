module Concerns
  module PageController
    extend ActiveSupport::Concern

    included do
      def page_image(page, image_type = :picture)
        photo_id = image_type == :picture ? page.photo_id : page.cover_photo_id

        redirect_to "/photos/#{photo_id}"
      end
    end
  end
end