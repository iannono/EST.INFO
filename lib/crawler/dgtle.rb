# 数字尾巴
#coding: utf-8
require 'nokogiri'
require 'open-uri'

count = 0
happend_at = ""
1.upto(5) do |i|
  url = "http://trade.dgtle.com/dgtle_module.php?mod=trade&ac=index&typeid=&PName=&searchsort=0&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.boardnav div.tradebox').each do |pd|
    happend_at = pd.css('p.tradeinfo span.tradedateline').first.content
    break if happend_at != Date.today.strftime('%Y-%m-%d')

    name = pd.css('p.tradetitle a').first.content
    user = pd.css('p.tradeuser').first.content
    img_link = pd.css('div.tradepic a img').first.attributes["src"].value
    pd_link = "http://trade.dgtle.com" + pd.css('div.tradepic a').first.attributes["href"].value
    price = pd.css('p.tradeprice').first.content
    city = pd.css('p.tradeprice span.city').first.content

    count += 1
    puts "finished ----#{count}--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "img link: " + img_link
    puts "product link: " + pd_link
    puts "user: " + user
    puts "price: " + price
    puts "city: " + city
    puts "happend_at: " + happend_at
  end

  break if happend_at != Date.today.strftime('%Y-%m-%d')
end
