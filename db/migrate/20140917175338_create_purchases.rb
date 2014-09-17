class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :total_price
      t.integer :user_id
      t.text :products
      t.integer :store_id
      t.boolean :success

      t.timestamps
    end
  end
end
