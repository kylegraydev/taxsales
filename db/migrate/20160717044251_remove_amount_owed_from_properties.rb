class RemoveAmountOwedFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :amount_owed
  end
end
