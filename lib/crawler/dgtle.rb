# 数字尾巴
#coding: utf-8
require './lib/crawler/base'

def generate_content(url) 
  content = fetch_body(url).content
  content
end

def handle_img_link(entry, url)
  html = fetch_body(url).inner_html

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["zoomfile"]
    name = download_img(img.attributes["zoomfile"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["zoomfile"])
    puts img.attributes["zoomfile"] 
  end
end

def save_img(entry, name, origin_link) 
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "public/pd_images/#{name}",
    img_name: name,
    source: "dgtle"
  )
end 

def fetch_body(url) 
  doc = Nokogiri::HTML(open(url))
  body = doc.css('td.t_f').first 
end 

def download_img(link, name)
  File.open("public/pd_images/#{name}.png", 'wb') do |f|
    f.write open(link).read
  end
  "#{name}.png"
end

happend_at = ""
1.upto(1) do |i|
  url = "http://trade.dgtle.com/dgtle_module.php?mod=trade&ac=index&typeid=&PName=&searchsort=0&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))

  linksdoc.css('div.boardnav div.tradebox').each do |pd|
    happend_at = pd.css('p.tradeinfo span.tradedateline').first.content
    break if happend_at != Date.today.strftime('%Y-%m-%d')

    name = pd.css('p.tradetitle a').first.content
    user = pd.css('p.tradeuser').first.content

    img_link = pd.css('div.tradepic a img').first.attributes["src"].value if pd.css('div.tradepic a img').first.try(:attributes) 

    pd_link = "http://trade.dgtle.com" + pd.css('div.tradepic a').first.attributes["href"].value
    content = generate_content(pd_link)

    price = pd.css('p.tradeprice').first.content
    city = pd.css('p.tradeprice span.city').first.content
    price = price.delete(city).strip if city

    puts "------------------------------------------------------------------------------------"
    puts "name: " + name
    puts "content: " + content
    puts "img link: " + img_link
    puts "product link: " + pd_link
    puts "user: " + user
    puts "price: " + price
    puts "city: " + city
    puts "happend_at: " + happend_at

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?  
      TwitterBot.delay.tweet(name, 12, pd_link) 
      entry.name= name
      entry.img = img_link || ""
      entry.img_name = download_img(img_link, (SecureRandom.hex 4)) || ""
      entry.content = content
      entry.user = user
      entry.price = price
      entry.city = city
      entry.source = "dgtle"
      entry.happend_at = Time.new
      entry.save

      handle_img_link(entry, pd_link)
    end
  end

  break if happend_at != Date.today.strftime('%Y-%m-%d')
end
