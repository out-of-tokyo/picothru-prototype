# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    total_price 342
    user_id 1
    products '[{"id":1,"price":108,"stock":-38,"store_id":1,"product_id":1,"created_at":"2014-09-09T14:13:37.000Z","updated_at":"2014-09-17T18:02:56.531Z"},{"id":3,"price":208,"stock":-35,"store_id":1,"product_id":2,"created_at":"2014-09-09T14:13:37.000Z","updated_at":"2014-09-17T18:02:56.537Z"}]'
    beacon_id 'D87CEE67-C2C2-44D2-A847-B728CF8BAAAD'
    success true
  end
end
