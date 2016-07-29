class AddZillowStatsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :use_code, :string
    add_column :properties, :bedrooms, :string
    add_column :properties, :bathrooms, :string
    add_column :properties, :finished_sq_ft, :string
    add_column :properties, :lot_size_sq_ft, :string
    add_column :properties, :year_built , :string
    add_column :properties, :zillow_url, :string
  end
end
