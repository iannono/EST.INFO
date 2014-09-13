module EntriesHelper
  def convert_source(source)
    case source
    when "dgtle" then "数字尾巴"
    when "macx" then "MACX"
    when "v2ex" then "V2EX"
    when "weiphone" then "威锋网"
    when "imp3" then "IMP3"
    end
  end

  def convert_price(price) 
    if price.nil? || price.nil?
      content_tag("span", "No Price", class: "no-price")
    else
      content_tag("span", "¥ #{price}", class: "price")
    end
  end
end
