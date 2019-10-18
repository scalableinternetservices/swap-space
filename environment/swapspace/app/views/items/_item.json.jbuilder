json.extract! item, :id, :category, :name, :user_id, :date_added, :created_at, :updated_at
json.url item_url(item, format: :json)
