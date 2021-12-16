json.extract! stock, :id, :name, :price, :quantity, :created_at, :updated_at
json.url stock_url(stock, format: :json)
