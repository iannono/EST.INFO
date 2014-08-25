#蜂鸟网
#coding: utf-8
require './lib/crawler/base'

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

    # puts "--------------------------------------------------------------------------------"
    # puts "name: " + name
    # puts "product link: " + pd_link
    # puts "user: " + user
    # puts "price: " + price
    # puts "city: " + city
    # puts "tag: " + tag
    # puts "brand: " + brand
    # puts "成色: " + condition
    # puts "happend_at: " + happend_at

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      #TwitterBot.delay.tweet(name, 12, pd_link)
      entry.name= name
      entry.user = user
      entry.price = price
      entry.city = city
      entry.source = "fengniao"
      entry.happend_at = Time.new
      entry.save
    end
  end

  break unless happend_at.include? Date.today.strftime('%m-%d')
end
