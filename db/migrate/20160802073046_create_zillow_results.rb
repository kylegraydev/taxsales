class CreateZillowResults < ActiveRecord::Migration
  def change
    create_table :zillow_results do |t|
      t.belongs_to :property
      t.string :use_code
      t.string :bedrooms
      t.string :bathrooms
      t.string :finished_sq_ft
      t.string :lot_size_sq_ft
      t.string :year_built
      t.string :zillow_url
      t.timestamps
    end
  end
end
