#v2ex.com
#coding: utf-8
require 'nokogiri'
require 'open-uri'

count = 0
happend_at = ""
1.upto(5) do |i|
  url = "http://v2ex.com/go/all4all?p=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div#TopicsNode div.cell').each do |pd|
    happend_at = pd.css('span.small').first.content
    break if happend_at.include? "1 天前"

    name = pd.css('span.item_title a').first.content
    pd_link = "http://v2ex.com" + pd.css('span.item_title a').first.attributes["href"].value
    user = pd.css('span.small strong a').first.content

    count += 1
    puts "finished ----#{count}--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "happend_at: " + happend_at
  end

  break if happend_at.include? "1 天前"
end
