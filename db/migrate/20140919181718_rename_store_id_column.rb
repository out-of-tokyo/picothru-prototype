class RenameStoreIdColumn < ActiveRecord::Migration
  def change
    rename_column :purchases, :store_id, :beacon_id
  end
end
