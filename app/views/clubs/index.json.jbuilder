json.array!(@clubs) do |club|
  json.extract! club, :name, :address, :description
  json.url club_url(club, format: :json)
end