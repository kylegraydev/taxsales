class AddDefaultedAmountToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :defaulted_amount, :string
  end
end
