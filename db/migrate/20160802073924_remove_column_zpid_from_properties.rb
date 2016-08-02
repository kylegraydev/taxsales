class RemoveColumnZpidFromProperties < ActiveRecord::Migration
  def change
      remove_column :properties, :zpid
  end
end
