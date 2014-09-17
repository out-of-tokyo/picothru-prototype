class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json

  helpers do
    def store_params
      "store_id=#{params[:store_id]}"
    end

    def barcode_id_params
      "barcode_id=#{params[:barcode_id]}"
    end

    def get_from endpoint, *params
      uri = URI.parse("#{endpoint}?#{params.join('&')}")
      JSON.load(Net::HTTP.get(uri))
    end
  end

  resource :product do
    get do
      get_from ENV['PRODUCT_ENDPOINT'], store_params, barcode_id_params
    end
  end

  resource :products do
    get do
      get_from ENV['PRODUCTS_ENDPOINT'], store_params
    end
  end

  resource :purchase do
    post do
      @purchase = Purchase.create( store_id: params[:store_id],
                                   total_price: params[:total_price], )

      # TODO: Ensure the transaction
      @purchase.post_to_pos params
      @purchase.webpay_with params[:token]
    end
  end
end
