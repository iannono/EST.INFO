module EntriesHelper
  def convert_source(source)
    case source
    when "dgtle" then "数字尾巴"
    when "macx" then "MACX"
    when "v2ex" then "V2EX"
    when "weiphone" then "威锋网"
    end
  end

  def convert_price(price) 
    if price.nil? || price.nil?
      "No Price"
    else
      "¥ #{price}"
    end
  end
end
