class RemoveAssesorsMapFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :assesors_map
    remove_column :properties, :aerial_image
    remove_column :properties, :street_image
    remove_column :properties, :defaulted_bill
  end
end
