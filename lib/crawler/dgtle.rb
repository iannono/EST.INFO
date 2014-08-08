# 数字尾巴
#coding: utf-8
require './lib/crawler/base'

happend_at = ""
1.upto(5) do |i|
  url = "http://trade.dgtle.com/dgtle_module.php?mod=trade&ac=index&typeid=&PName=&searchsort=0&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.boardnav div.tradebox').each do |pd|
    happend_at = pd.css('p.tradeinfo span.tradedateline').first.content
    break if happend_at != Date.today.strftime('%Y-%m-%d')

    name = pd.css('p.tradetitle a').first.content
    user = pd.css('p.tradeuser').first.content
    img_link = pd.css('div.tradepic a img').first.attributes["src"].value if pd.css('div.tradepic a img').first.try(:attributes)
    pd_link = "http://trade.dgtle.com" + pd.css('div.tradepic a').first.attributes["href"].value
    price = pd.css('p.tradeprice').first.content
    city = pd.css('p.tradeprice span.city').first.content
    price = price.delete(city).strip if city

    #puts "------------------------------------------------------------------------------------"
    #puts "name: " + name
    #puts "img link: " + img_link
    #puts "product link: " + pd_link
    #puts "user: " + user
    #puts "price: " + price
    #puts "city: " + city
    #puts "happend_at: " + happend_at

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      entry.name= name
      entry.img = img_link || ""
      entry.user = user
      entry.price = price
      entry.city = city
      entry.source = "dgtle"
      entry.happend_at = Time.new
      entry.save
    end
  end

  break if happend_at != Date.today.strftime('%Y-%m-%d')
end
