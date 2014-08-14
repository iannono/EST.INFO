require 'twitter'
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "FO6NS2xPvwX0nLQmVNuMwrFrO"
  config.consumer_secret     = "FUm0lfgBKn8iCRHfhJFGnaWUPk0cSWBEUeZ8nv0ucIKshlzDIH"
  config.access_token        = "2728912848-MTMr5Y17QCFcMcohFyccXCDBywUjswuy4coBG1L"
  config.access_token_secret = "QYKmoUvOseBc4z81yTdMyYi1xmNaEmvhmU60XdZSBSfYa"
end

user = client.user("xiongbo027")
client.update("I'm tweeting with @gem!")
