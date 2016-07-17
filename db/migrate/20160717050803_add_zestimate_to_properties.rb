class AddZestimateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :zestimate, :string
  end
end
