class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json

  resource :products do
    get do
      parameters = "store_id=#{params[:store_id]}"
      uri = URI.parse("#{ENV['PRODUCTS_ENDPOINT']}?#{parameters}")
      JSON.load(Net::HTTP.get(uri))
    end
  end

  resource :purchase do
    post do
      @product = Purchase.create( store_id: params[:store_id],
                                  total_price: params[:total_price], )
      @product.post_to_pos params
    end
  end
end
