class Purchase < ActiveRecord::Base
  validates :total_price, presence: true
  validates :success, presence: true
  validates :products, presence: true
  validates :store_id, presence: true
end
