#www.macx.cn
#coding: utf-8
require './lib/crawler/base'

def generate_content(url)
  body = fetch_body(url)
  filter_content(body)
end

def filter_content(body)
  if body
    igs = body.search("ignore_js_op")
    igs.remove
    scripts = body.search("script")
    scripts.remove
  end
  body.try(:content).try(:strip)
end

def fetch_body(url)
  doc = Nokogiri::HTML(open(url))
  body = doc.css('div.pcb').first
end

def handle_img_link(entry, url)
  html = fetch_body(url).inner_html

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["file"]
    #puts img.attributes["file"]
    name = download_img(img.attributes["file"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["file"])
  end
end

def save_img(entry, name, origin_link)
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "/pd_images/#{name}",
    img_name: name,
    source: "macx"
  )
end

def download_img(link, name)
  File.open("./public/pd_images/#{name}.jpg", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.jpg"
rescue => e
  puts "download_img error: #{e}"
  return
end

happend_at = ""
1.upto(1) do |i|
  url = "http://www.macx.cn/forum.php?mod=forumdisplay&fid=10001&filter=author&orderby=dateline&sortall=1&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.bm_c ul.ml li').each do |pd|
    name = pd.css('h3.ptn a').first.content
    next if name.include? "[置顶]"

    happend_at = pd.css('div.cl').last.css('em.xs0').last.content
    break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")

    pd_link = pd.css('h3.ptn a').first.attributes["href"].value
    content = generate_content(pd_link)
    city = content.match(/地区:\r\n.*\r\n/).to_s.delete("地区:").try(:strip)
    price = content.match(/出售价格:\r\n.*\r\n/).to_s.delete("出售价格:").try(:strip)
    content = content.gsub(/:\r\n/, ":\r").gsub("\r\n\r\n\r\n", "\r\n")

    #puts "-----------------------------------------------"
    #puts "name: " + name
    #puts "product link: " + pd_link if pd_link
    #puts "city: " + city
    #puts "price: " + price
    #puts "happend_at: " + happend_at
    #puts "content: " + content unless content.blank?

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay.tweet(name, price, pd_link)
      entry.name= name
      entry.source = "macx"
      entry.happend_at = Time.new
      entry.content = content
      entry.city = city unless city.blank?
      entry.price = price unless price.blank?
      entry.save

      handle_img_link(entry, pd_link)
      update_entry_img(entry)
    end
  end

  break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")
end
