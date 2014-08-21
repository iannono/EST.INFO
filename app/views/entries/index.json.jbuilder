json.array!(@entries) do |entry|
  json.extract! entry, :name, :city, :img, :product, :happend_at
  json.source convert_source(entry.source)
  json.price convert_price(entry.price)
end
