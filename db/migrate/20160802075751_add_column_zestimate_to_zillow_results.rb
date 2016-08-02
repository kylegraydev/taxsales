class AddColumnZestimateToZillowResults < ActiveRecord::Migration
  def change
    add_column :zillow_results, :zestimate, :string
  end
end
