class AddAerialImageColumnToProperties < ActiveRecord::Migration
  def change
    add_attachment :properties, :aerial_image
  end
end
