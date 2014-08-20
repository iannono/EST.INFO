json.array!(@entries) do |entry|
  json.extract! entry, :name, :source, :city, :price, :img, :product, :happend_at
end
