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
end