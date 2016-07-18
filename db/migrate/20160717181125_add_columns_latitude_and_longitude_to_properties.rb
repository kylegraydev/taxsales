class AddColumnsLatitudeAndLongitudeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :latitude, :string
    add_column :properties, :longitude, :string
  end
end
