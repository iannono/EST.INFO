json.extract! @entry, :product, :city
json.content @entry.full_content
json.source convert_source(@entry.source)
json.time "#{time_ago_in_words @entry.happend_at}前"
