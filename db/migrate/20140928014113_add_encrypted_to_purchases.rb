class AddEncryptedToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :encrypted, :text
  end
end
