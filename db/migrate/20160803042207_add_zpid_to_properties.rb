class AddZpidToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :zpid, :string
  end
end
