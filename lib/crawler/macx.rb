#www.macx.cn
#coding: utf-8
require './lib/crawler/base'

happend_at = ""
1.upto(5) do |i|
  url = "http://www.macx.cn/forum.php?mod=forumdisplay&fid=10001&filter=author&orderby=dateline&sortall=1&page=#{i}"
  linksdoc = Nokogiri::HTML(open(url))
  linksdoc.css('div.bm_c ul.ml li').each do |pd|
    name = pd.css('h3.ptn a').first.content
    next if name.include? "[置顶]"

    happend_at = pd.css('div.cl').last.css('em.xs0').last.content
    break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")

    pd_link = pd.css('h3.ptn a').first.attributes["href"].value
    img_link = pd.css('div.c a img').first.attributes["src"].value if pd.css('div.c a img').first.try(:attributes)

    puts "--------------------------------------------------------------------------------"
    puts "name: " + name
    puts "img link: " + img_link
    puts "product link: " + pd_link
    puts "happend_at: " + happend_at

    entry = Entry.find_or_initialize_by(product: pd_link)
    if entry.new_record?
      TwitterBot.tweet(name, 12, pd_link)
      entry.name= name
      entry.img = img_link || ""
      entry.source = "macx"
      entry.happend_at = Time.new
      entry.save
    end
  end

  break if happend_at != Date.today.strftime('%y-%m-%d').gsub("-0", "-")
end
