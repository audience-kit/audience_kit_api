module Concerns
  module PageController
    extend ActiveSupport::Concern

    included do
      def page_image(page, image_type = :picture)
        mime_type = page.send("#{image_type}_mime".to_sym)
        data = page.send("#{image_type}_image".to_sym)

        send_data data, type: mime_type
      end
    end
  end
end