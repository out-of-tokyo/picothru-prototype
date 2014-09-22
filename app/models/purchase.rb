class Purchase < ActiveRecord::Base
  validates :total_price, presence: true
  validates :success, presence: true
  validates :products, presence: true
  validates :beacon_id, presence: true

  def purchase_post_to_pos params
    res = (post_to_pos ENV['PURCHASE_ENDPOINT'], params)
    self.update( success: true, products: res, ) if res
    !!res
  end

  def cancel_purchase_post_to_pos params
    res = (post_to_pos ENV['CANCEL_PURCHASE_ENDPOINT'], params)
    self.update( success: true, products: res, ) if res
    !!res
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

  private

  def post_to_pos endpoint, params
    http_client = HTTPClient.new
    http_client.post_content(endpoint,
                             params.to_json,
                             'Content-Type' => 'application/json')
  end
end
