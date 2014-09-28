class Purchase < ActiveRecord::Base
  validates :total_price, presence: true
  validates :success, presence: true
  validates :products, presence: true
  validates :beacon_id, presence: true

  def init_with encrypted_purchase
    self.encrypted = encrypted_purchase
    params = Hash[decrypted.map{ |k, v|
      v = v.to_s; [k, v]
    }]
    self.tap { |purchase| purchase.attributes = params }
  end

  def purchase_post_to_pos
    res = (post_to_pos ENV['PURCHASE_ENDPOINT'], decrypted)
    self.update( success: true, products: res, ) if res
    !!res
  end

  def cancel_purchase_post_to_pos
    res = (post_to_pos ENV['CANCEL_PURCHASE_ENDPOINT'], decrypted)
    self.update( success: true, products: res, ) if res
    !!res
  end

  def webpay
    webpay = WebPay.new(ENV['WEBPAY_SECRET'])
    res = webpay.charge.create(
            amount: self.total_price,
            currency: 'jpy',
            card: self.token
          )
    res.paid # => true
  end

  private

  def decrypted
    decrypted_str =  AESCrypt.decrypt(self.encrypted, ENV['AES_SECRET_KEY'])
    JSON.load decrypted_str
  end

  def post_to_pos endpoint, params
    http_client = HTTPClient.new
    http_client.post_content(endpoint,
                             params.to_json,
                             'Content-Type' => 'application/json')
  end
end
