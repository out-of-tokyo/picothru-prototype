class Purchase < ActiveRecord::Base
  validates :total_price, presence: true
  validates :success, presence: true
  validates :products, presence: true
  validates :store_id, presence: true

  def post_to_pos params
    http_client = HTTPClient.new
    res = http_client.post_content(ENV['PURCHASE_ENDPOINT'],
                                   params.to_json,
                                   'Content-Type' => 'application/json')

    self.update( success: true, products: res, ) if res
    res
  end

  def webpay_with token
    webpay = WebPay.new(ENV['WEBPAY_SECRET'])
    res = webpay.charge.create(
            amount: self.total_price,
            currency: 'jpy',
            card: token
          )
    res.paid # => true
  end
end
