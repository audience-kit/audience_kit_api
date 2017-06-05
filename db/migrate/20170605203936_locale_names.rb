class LocaleNames < ActiveRecord::Migration[5.1]
  def change
    add_column :locales, :city_names, :string, array: true
  end
end
