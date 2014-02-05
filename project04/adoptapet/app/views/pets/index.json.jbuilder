json.array!(@pets) do |pet|
  json.extract! pet, :id, :petkind, :name, :description, :image_url, :price
  json.url pet_url(pet, format: :json)
end
