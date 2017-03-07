class ExtendLocales < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :name_override, :string
    add_column :people, :name_override, :string
    add_column :events, :name_override, :string

    add_column :sessions, :version, :string
    add_column :sessions, :build, :integer
    add_column :devices, :model, :string

    add_column :people, :order, :integer
    add_column :events, :order, :integer
    add_column :venues, :order, :integer

    rename_column :people, :display_name, :name
  end
end
