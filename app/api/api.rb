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

    def get_from endpoint, *keys
      http_client = HTTPClient.new
      params_for_url = keys.map{ |key| "#{key}=#{allowed_params[key]}" }
      url = "#{endpoint}?#{params_for_url.join('&')}"
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
      get_from ENV['PRODUCT_ENDPOINT'], 'beacon_id', 'barcode_id'
    end
  end

  resource :products do
    params { use :require_beacon_id }
    get do
      get_from ENV['PRODUCTS_ENDPOINT'], 'beacon_id'
    end
  end

  resource :newspapers do
    params { use :require_beacon_id }
    get do
      get_from ENV['NEWSPAPERS_ENDPOINT'], 'beacon_id'
    end
  end

  resource :purchase do
    params do
      use :require_encrypted_purchase
    end

    post do
      @purchase = Purchase.new.init_with allowed_params['encrypted_purchase']
      if responce_from_pos = @purchase.purchase_post_to_pos
        begin
          responce_from_webpay = @purchase.webpay
        rescue => e
          @purchase.cancel_purchase_post_to_pos
          return e.message
        end

        { responce_from_pos: responce_from_pos,
          responce_from_webpay: responce_from_webpay }
      end
    end
  end

   add_swagger_documentation api_version: 'v0'
end
