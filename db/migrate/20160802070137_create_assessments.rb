class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.belongs_to :property
      t.string :use_type
      t.string :year_assessed
      t.string :total_value
      t.string :bdr
      t.string :ba
      t.string :bldg_sqft
      t.string :lot_acres
      t.string :year_built
      t.string :sale_amount
      t.string :recording_date
      t.timestamps
    end
  end
end
