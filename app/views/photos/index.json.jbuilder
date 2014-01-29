json.array!(@photos) do |photo|
  json.extract! photo, :description, :user_id, :micropost_id
  json.url photo_url(photo, format: :json)
end