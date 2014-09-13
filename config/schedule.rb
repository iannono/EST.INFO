set :output, 'log/cron.log'

every 5.minutes do
  rake "crawler:feng"
end

every 6.minutes do
  rake "crawler:imp3"
end

every 8.minutes do
  rake "crawler:dgtle"
end

every 15.minutes do
  rake "crawler:v2ex"
end

every '0 2 1 * *' do
  runner "Entry.clean"
end
