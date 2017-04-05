# frozen_string_literal: true

class RemoveImagesLocally < ActiveRecord::Migration[5.0]
  def change
    remove_column :photos, :content

    change_column_null :photos, :cdn_url, false
  end
end
