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
      url = "http://#{ENV['POS_SERVER_DOMAIN']}/api/v0/purchase"
      http_client = HTTPClient.new
      res = http_client.post_content(url, params.to_json, 'Content-Type' => 'application/json')
    end
  end
end
