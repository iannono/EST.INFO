set :output, 'log/cron.log'
every 3.minutes do
  rake "crawler:dgtle"
  rake "crawler:macx"
  rake "crawler:feng"
  rake "crawler:v2ex"
end
