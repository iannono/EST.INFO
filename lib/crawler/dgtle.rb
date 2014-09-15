# 数字尾巴
#encoding: utf-8
require './lib/crawler/base' 

def filter_content(body) 
  igs = body.search("ignore_js_op")
  igs.try(:remove) 
  scripts = body.search("script")
  scripts.try(:remove)
  body.content.strip
end

def handle_img_link(entry, doc)
  html = fetch_body(doc, 'div.t_fsz').inner_html

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["file"]
    name = download_img(img.attributes["file"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["file"])
  end
end

def save_img(entry, name, origin_link)
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "/pd_images/#{name}",
    img_name: name,
    source: "dgtle"
  )
end 

def download_img(link, name)
  File.open("public/pd_images/#{name}.png", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.png"
rescue => e
  return
end

count = 0
happend_at = ""
url = "http://trade.dgtle.com/dgtle_module.php?mod=trade&ac=index&typeid=&PName=&searchsort=0&page=1"
linksdoc = Nokogiri::HTML(open(url))

linksdoc.css('div.boardnav div.tradebox').reverse.each_with_index do |pd, index|

  begin
    happend_at = pd.css('p.tradeinfo span.tradedateline').first.content
    next if happend_at != Date.today.strftime('%Y-%m-%d')

    pd_link = "http://trade.dgtle.com" + pd.css('div.tradepic a').first.attributes["href"].value
    doc = get_doc(pd_link)

    body = fetch_body(doc.dup, 'div.t_fsz')
    next unless has_imgs?(body) 

    content = filter_content(body) 
    name = pd.css('p.tradetitle a').first.content
    user = pd.css('p.tradeuser').first.content
    price = pd.css('p.tradeprice').first.content || ""
    city = pd.css('p.tradeprice span.city').first.content
    price = price.delete(city).strip if city
    price = /(\d+)/.match(price)[0] 
    category = fetch_body(doc, ".cr_date font").content.strip


    puts "------------------------------"
    puts "name: " + name
    puts "content: " + content
    puts "product link: " + pd_link
    puts "user: " + user
    puts "price: " + price
    puts "city: " + city
    puts "happend_at: " + happend_at
    puts "category: " + category

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay(run_at: (index*20).seconds.from_now).tweet(name, price, pd_link)
      entry.name= name
      entry.content = content
      entry.user = user
      entry.price = price
      entry.city = city
      entry.source = "dgtle"
      entry.happend_at = Time.new
      entry.category = category
      entry.save

      handle_img_link(entry, doc.dup)
      update_entry_img(entry)
      entry.delay.upload_to_qiniu
      count += 1
    end
  rescue => e
    puts "dgtle: #{e}"
    next
  end
end

puts "Add #{count} entries from dgtle at #{Time.new}."
