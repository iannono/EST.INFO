# IMP3
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
url = "http://bbs.imp3.net/forum.php?mod=forumdisplay&fid=63&orderby=dateline&filter=dateline&dateline=86400&orderby=dateline"
linksdoc = Nokogiri::HTML(open(url))

linksdoc.css("tbody[id^='normalthread']").reverse.each_with_index do |pd, index|

  begin

    next unless pd.css("img[alt='attach_img']").first.present?

    happend_at = pd.css('span.xi1').first.content
    name = pd.css("a.s.xst").first.content
    user = pd.css('cite a').first.content
    category = pd.css("em a").first.try(:content)

    pd_link = pd.css('a.s.xst').first.attributes["href"].value 
    doc = get_doc(pd_link)

    body = fetch_body(doc.dup, "table.cgtl.mbm")
    content = filter_content(body) 
    city = content.match(/所在地:\r\n.*\r\n/).to_s.delete("所在地:").try(:strip)
    price = content.match(/商品价格:\r\n.*\r\n/).to_s.delete("商品价格:").try(:strip)
    price = price.to_s.match(/\d{1,}/).to_s if price.present?

    body = fetch_body(doc.dup, ".t_fsz")
    content = filter_content(body)

    puts "------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "price: " + price
    puts "city: " + city
    puts "content: " + content
    puts "catetory: " + category

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay(run_at: (index*20).seconds.from_now).tweet(name, price, pd_link)
      entry.name= name
      entry.content = content
      entry.user = user
      entry.price = price
      entry.city = city
      entry.source = "imp3"
      entry.happend_at = Time.new
      entry.category = category
      entry.save 

      handle_img_link(entry, doc.dup)
      update_entry_img(entry)
      entry.delay.upload_to_qiniu
      count += 1
    end
    sleep 8
  rescue => e
    puts "imp3: #{e}"
    next
  end
end

puts "Add #{count} entries from imp3 at #{Time.new}." 
