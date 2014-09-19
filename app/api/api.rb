class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json

  helpers do
    def beacon_id_params
      "beacon_id=#{params[:beacon_id]}"
    end

    def barcode_id_params
      "barcode_id=#{params[:barcode_id]}"
    end

    def get_from endpoint, *params
      http_client = HTTPClient.new
      url = "#{endpoint}?#{params.join('&')}"
      JSON.load(http_client.get_content(url).force_encoding('utf-8'))
    end
  end

  resource :product do
    get do
      get_from ENV['PRODUCT_ENDPOINT'], beacon_id_params, barcode_id_params
    end
  end

  resource :products do
    get do
      get_from ENV['PRODUCTS_ENDPOINT'], beacon_id_params
    end
  end

  resource :newspapers do
    get do
      get_from ENV['NEWSPAPERS_ENDPOINT'], beacon_id_params
    end
  end

  resource :purchase do
    post do
      @purchase = Purchase.create( beacon_id: params[:beacon_id],
                                   total_price: params[:total_price], )

      # TODO: Ensure the transaction
      @purchase.post_to_pos params
      @purchase.webpay_with params[:token]
    end
  end
end
