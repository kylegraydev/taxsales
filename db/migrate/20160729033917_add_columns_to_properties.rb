class AddColumnsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :street_address, :string
    add_column :properties, :city, :string
    add_column :properties, :zip, :string
  end
end
