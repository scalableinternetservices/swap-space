json.extract! item, :id, :category, :name, :user_id, :created_at, :updated_at
json.url item_url(item, format: :json)
