#威锋网
#encoding: utf-8
require './lib/crawler/base'

def filter_content(body)
  if body
    igs = body.search("ignore_js_op")
    igs.remove
    scripts = body.search("script")
    scripts.remove
    status = body.search("i")
    status.remove
  end
  body.try(:content).try(:strip)
end

def handle_img_link(entry, doc)
  html = fetch_body(doc, 'div.t_fsz').inner_html

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
    source: "feng"
  )
end

def download_img(link, name)
  File.open("./public/pd_images/#{name}.jpg", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.jpg"
end

count = 0
#happend_at = ""
url = "http://bbs.feng.com/forum.php?mod=forumdisplay&fid=29&orderby=dateline&filter=dateline&dateline=86400&orderby=dateline"
linksdoc = Nokogiri::HTML(open(url).read)

linksdoc.css("tbody[id^='normalthread']").reverse.each_with_index do |pd, index|
  begin 

    next unless pd.css("img[alt='attach_img']").first.present?

    name = pd.css('a.xst').first.content
    user = pd.css('td.by a').first.try(:content)
    category = pd.css("em a").first.try(:content) 
    next if category.include? "求购"

    pd_link = "http://bbs.feng.com/" + pd.css('tr th.new a.xst').first.attributes["href"].value 
    doc = get_doc(pd_link) 

    body = fetch_body(doc.dup, 'div.t_fsz') 
    content = filter_content(body)

    price = content.match(/现在.?\d{1,5}/)
    price = content.match(/价.?\d{1,5}/) if price.blank?
    price = content.match(/价格.?\d{1,5}/) if price.blank?
    price = content.match(/\d{1,5}元/) if price.blank?
    price = content.match(/￥.?\d{1,5}/) if price.blank?
    price = price.to_s.match(/\d{1,}/).to_s if price.present?

    puts "---------------------------------------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "content: " + content unless content.blank?
    puts "category: " + category

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay(run_at: (index*10).seconds.from_now).tweet(name, nil, pd_link)
      entry.name= name
      entry.user= user
      entry.source = "weiphone"
      entry.happend_at = Time.new
      entry.content = content
      entry.category = category
      entry.save

      handle_img_link(entry, doc.dup)
      update_entry_img(entry)
      entry.delay.upload_to_qiniu
      count += 1
    end
    sleep 5
  rescue => e
    puts "weiphone: #{e}"
    next
  end
end

puts "Add #{count} entries from weiphone at #{Time.new}."
