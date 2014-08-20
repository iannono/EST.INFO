#v2ex.com
#coding: utf-8
require './lib/crawler/base'

agent = Mechanize.new
agent.get('http://v2ex.com/signin') do |login_page| 
  login_form = login_page.forms[1]
  login_form.u = "xiongbo"
  login_form.p = "86480627q"
  logined_page = agent.submit(login_form) 
end 

def generate_content(url, agent) 
  body = fetch_body(url, agent)
  filter_content(body)
end

def fetch_body(url, agent) 
  doc = Nokogiri::HTML(agent.get(url).body)
  body = doc.css('div.topic_content').first 
end 

def filter_content(body) 
  body.try(:content).nil? ? "" : body.try(:content).strip
end

def handle_img_link(entry, url, agent)
  return unless html = fetch_body(url, agent).try(:inner_html) 

  Nokogiri::HTML(html).css('img').each do |img|
    next unless img.attributes["src"]
    puts img.attributes["src"]
    name = download_img(img.attributes["src"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["src"])
  end
end

def save_img(entry, name, origin_link) 
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: "/pd_images/#{name}",
    img_name: name,
    source: "v2ex"
  )
end 

def download_img(link, name)
  File.open("public/pd_images/#{name}.png", 'wb') do |f|
    f.write open(link, :read_timeout => 600).read
  end
  "#{name}.png"
end 

happend_at = ""
1.upto(1) do |i|
  url = "http://v2ex.com/go/all4all?p=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div#TopicsNode div.cell').each do |pd|
    happend_at = pd.css('span.small').first.content
    break if happend_at.include? "1 天前"

    name = pd.css('span.item_title a').first.content
    pd_link = "http://v2ex.com" + pd.css('span.item_title a').first.attributes["href"].value
    content = generate_content(pd_link, agent)
    user = pd.css('span.small strong a').first.content

    puts "--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "happend_at: " + happend_at
    puts "content: " + content

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay.tweet(name, nil, pd_link)
      entry.name= name
      entry.user = user
      entry.content = content || ""
      entry.source = "v2ex"
      entry.happend_at = Time.new
      entry.save

      handle_img_link(entry, pd_link, agent)
      update_entry_img(entry)
    end
    break if happend_at.include? "1 天前"
  end
end
