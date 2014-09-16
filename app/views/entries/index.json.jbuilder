json.array!(@entries) do |entry|
  json.extract! entry, :name, :city, :img, :product, :category
  json.source convert_source(entry.source)
  json.price convert_price(entry.price)
  json.created_at entry.created_at.strftime('%Y-%m-%d %H:%M:%S')
end
