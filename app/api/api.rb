class API < Grape::API
  prefix 'api'
  version 'v0', using: :path
  format :json
  rescue_from :all do |e|
    error_response({ message: e.message })
  end

  ALLOWED_PARAMS = [:beacon_id, :barcode_id, :encrypted_purchase, products: [:barcode_id, :amount]].freeze

  helpers do
    def allowed_params
      ActionController::Parameters.new(params).permit(ALLOWED_PARAMS)
    end

    def beacon_id_params
      "beacon_id=#{allowed_params[:beacon_id]}"
    end

    def barcode_id_params
      "barcode_id=#{allowed_params[:barcode_id]}"
    end

    def get_from endpoint, *params
      http_client = HTTPClient.new
      url = "#{endpoint}?#{params.join('&')}"
      JSON.load(http_client.get_content(url).force_encoding('utf-8'))
    end

    params :require_beacon_id do requires :beacon_id, type: String end
    params :require_barcode_id do requires :barcode_id, type: Integer end
    params :require_encrypted_purchase do requires :encrypted_purchase, type: String end
    params :require_products do
      requires :products, type: Array do
        requires :barcode_id
        requires :amount
      end
    end
  end

  resource :product do
    params { use :require_beacon_id, :require_barcode_id }
    get do
      get_from ENV['PRODUCT_ENDPOINT'], beacon_id_params, barcode_id_params
    end
  end

  resource :products do
    params { use :require_beacon_id }
    get do
      get_from ENV['PRODUCTS_ENDPOINT'], beacon_id_params
    end
  end

  resource :newspapers do
    params { use :require_beacon_id }
    get do
      get_from ENV['NEWSPAPERS_ENDPOINT'], beacon_id_params
    end
  end

  resource :purchase do
    params do
      use :require_encrypted_purchase
    end

    post do
      purchase_str = AESCrypt.decrypt(allowed_params[:encrypted_purchase], ENV['AES_SECRET_KEY'])
      purchase = JSON.load purchase_str
      @purchase = Purchase.create( beacon_id: purchase['beacon_id'],
                                   total_price: purchase['total_price'], )
      if responce_from_pos = (@purchase.purchase_post_to_pos purchase)
        begin
          responce_from_webpay = (@purchase.webpay_with purchase['token'])
        rescue => e
          @purchase.cancel_purchase_post_to_pos purchase
          return e.message
        end

        { responce_from_pos: responce_from_pos,
          responce_from_webpay: responce_from_webpay }
      end
    end
  end

   add_swagger_documentation api_version: 'v0'
end
