#蜂鸟网
#coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'date'
require './lib/crawler/base'

count = 0
happend_at = ""
1.upto(5) do |i|
  url = "http://www.fengniao.com/secforum/sec_index.php?s=&forumid=79&daysprune=1&sortorder=descdescdescdesc&sortfield=dateline&perpage=40&excerption=0&pid=0&bid=0&cid=0&bsid=0&stid=0&uid=0&tkey=&ukey=&pagenumber=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('table.discuss-list tbody tr').each do |pd|
    tag = pd.css('td.row-1').first.content
    next unless tag.include? "出售"
    brand =  pd.css('td.row-2').first.content
    name = pd.css('td.row-3').first.content
    next if name.include? "置顶"

    happend_at = pd.css('td.row-10').first.content
    break unless happend_at.include? Date.today.strftime('%m-%d')

    user = pd.css('td.row-4').first.content
    pd_link = pd.css('td.row-3 p a').first.attributes["href"].value
    price = pd.css('td.row-7').first.content
    city = pd.css('td.row-5 a').first.content
    condition = pd.css('td.row-6').first.content

    count += 1
    puts "finished ----#{count}--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "product link: " + pd_link
    puts "user: " + user
    puts "price: " + price
    puts "city: " + city
    puts "tag: " + tag
    puts "brand: " + brand
    puts "成色: " + condition
    puts "happend_at: " + happend_at

    Entry.create(name: name,
                 product: pd_link,
                 user: user,
                 price: price,
                 city: city,
                 source: "fengniao",
                 happend_at: happend_at)
  end

  break unless happend_at.include? Date.today.strftime('%m-%d')
end
