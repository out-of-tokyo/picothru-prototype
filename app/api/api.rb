class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json

  resource :products do
    get do
      url = "http://#{ENV['POS_SERVER_DOMAIN']}/api/v0/products"
      parameters = "store_id=#{params[:store_id]}"
      uri = URI.parse("#{url}?#{parameters}")
      JSON.load(Net::HTTP.get(uri))
    end
  end

  resource :purchase do
    post do
      @product = Purchase.create( store_id: params[:store_id],
                                  total_price: params[:total_price], )
      url = "http://#{ENV['POS_SERVER_DOMAIN']}/api/v0/purchase"
      http_client = HTTPClient.new
      if res = http_client.post_content(url,
                                        params.to_json,
                                        'Content-Type' => 'application/json')
        @product.update( success: true,
                         products: res, )
      end
      res
    end
  end
end
