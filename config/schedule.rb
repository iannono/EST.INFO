set :output, 'log/cron.log'

every 5.minutes do
  rake "crawler:feng"
end

every 8.minutes do
  rake "crawler:v2ex"
end

every 10.minutes do
  rake "crawler:macx"
end

every 15.minutes do
  rake "crawler:dgtle"
end
