class CreateTaxSales < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :parcel_num
      t.string :name
      t.string :address
      t.string :legal_desc
      t.string :min_bid
      t.string :grid_num
      t.string :amount_owed
      t.binary :assesors_map
      t.binary :aerial_image
      t.binary :street_image
      t.binary :defaulted_bill
    end
  end
end
