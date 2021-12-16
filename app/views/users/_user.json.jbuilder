json.extract! user, :id, :full_name, :user_status, :created_at, :updated_at
json.url user_url(user, format: :json)
