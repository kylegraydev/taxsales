class AddStreetAddressAndZipToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :street_address, :string
    add_column :assessments, :zip, :string
  end
end
