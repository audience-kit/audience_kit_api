class LocaleAddTimezone < ActiveRecord::Migration[5.0]
  def change
    add_column :locales, :timezone_zulu_delta, :integer
  end
end
