class RemoveZestimateFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :zestimate
  end
end
