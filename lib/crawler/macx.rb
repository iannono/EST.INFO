#www.macx.cn
#coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'date'
require './lib/crawler/base'

count = 0
happend_at = ""
name= ""
1.upto(5) do |i|
  url = "http://www.macx.cn/forum.php?mod=forumdisplay&fid=10001&filter=author&orderby=dateline&sortall=1&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.bm_c ul.ml li').each do |pd|
    name = pd.css('h3.ptn a').first.content
    next if name.include? "[置顶]"

    happend_at = pd.css('div.cl').last.css('em.xs0').last.content
    break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")

    pd_link = pd.css('h3.ptn a').first.attributes["href"].value
    img_link = pd.css('div.c a img').first.attributes["src"].value

    count += 1
    puts "finished ----#{count}--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "img link: " + img_link
    puts "product link: " + pd_link
    puts "happend_at: " + happend_at

    Entry.create(name: name,
                 img: img_link,
                 product: pd_link,
                 source: "macx",
                 happend_at: happend_at)
  end

  break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")
end
