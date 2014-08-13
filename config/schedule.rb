set :output, 'log/cron.log'
every 3.minutes do
  rake "crawler:dgtle"
  rake "crawler:fengniao"
  rake "crawler:macx"
  rake "crawler:v2ex"
end
