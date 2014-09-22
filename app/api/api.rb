class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json
  rescue_from :all do |e|
    error_response({ message: e.message })
  end

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
      if responce_from_pos = (@purchase.purchase_post_to_pos params)
        unless responce_from_webpay = (@purchase.webpay_with params[:token])
          @purchase.cancel_purchase_post_to_pos params
        end
        { responce_from_pos: responce_from_pos,
          responce_from_webpay: responce_from_webpay }
      end
    end
  end
end
