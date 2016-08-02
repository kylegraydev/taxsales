class DropColumnsFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :use_code
    remove_column :properties, :bedrooms
    remove_column :properties, :bathrooms
    remove_column :properties, :finished_sq_ft
    remove_column :properties, :lot_size_sq_ft
    remove_column :properties, :year_built
    remove_column :properties, :zillow_url
  end
end
