class RemoveColumnsStreetAddressAndZipFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :street_address
    remove_column :properties, :zip
    remove_column :properties, :city
  end
end
