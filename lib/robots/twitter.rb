require 'twitter'

class TwitterBot
  def self.tweet(name, price, link)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "FO6NS2xPvwX0nLQmVNuMwrFrO"
      config.consumer_secret     = "FUm0lfgBKn8iCRHfhJFGnaWUPk0cSWBEUeZ8nv0ucIKshlzDIH"
      config.access_token        = "2728912848-MTMr5Y17QCFcMcohFyccXCDBywUjswuy4coBG1L"
      config.access_token_secret = "QYKmoUvOseBc4z81yTdMyYi1xmNaEmvhmU60XdZSBSfYa"
    end

    _msg = format_message(name, price, link)
    client.update(_msg)
  end

  def self.format_message(name, price, link)
    "#{name.slice(0..60)}...[$#{price}:#{link}]"
  end
end 
