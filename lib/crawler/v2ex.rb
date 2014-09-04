#v2ex.com
#coding: utf-8
require './lib/crawler/base'
require 'net/http'
require 'json'
require 'time'
require 'pry'


def handle_img_link(entry, body)
  return if body.blank?

  Nokogiri::HTML(body).css('img').each do |img|
    next unless img.attributes["src"]
    name = download_img(img.attributes["src"], (SecureRandom.hex 4))
    save_img(entry, name, img.attributes["src"])
  end
end

def save_img(entry, name, origin_link)
  entry.images.create!(
    img_origin_link: origin_link.to_s,
    img_link: image_link_qiniu,
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

url = "https://www.v2ex.com/api/topics/show.json?node_name=all4all"
response = Net::HTTP.get_response(URI(url))
body = JSON.parse(response.body)
body.each_with_index do |pd, index|
  begin
    pd_link = pd["url"]
    happend_at = Time.at(pd["created"])
    content_rendered = pd["content_rendered"]
    name = pd["title"]
    break unless happend_at.strftime('%Y-%m-%d') == Date.today.strftime('%Y-%m-%d')
    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.delay(run_at: (index*40).seconds.from_now).tweet(name, nil, pd_link)
      entry.name= name
      entry.user = pd["member"]["username"]
      entry.content = pd["content_rendered"] || ""
      entry.source = "v2ex"
      entry.happend_at = happend_at
      entry.save

      handle_img_link(entry, content_rendered)
      update_entry_img(entry)
    end
    sleep 3
  rescue => e
    puts "v2ex: #{e}"
    next
  end
end

