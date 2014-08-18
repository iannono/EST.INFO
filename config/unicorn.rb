RAILS_ROOT = File.expand_path("../..", __FILE__)

application = "estao"
user = ENV['USER'] || 'estao'

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 1)
timeout 240
preload_app true

listen "/tmp/unicorn.#{application}.socket", :backlog => 64

app_path = "/home/#{user}/apps/#{application}"
shared_path = "#{app_path}/shared"
current_path = "#{app_path}/current"
pid "#{shared_path}/tmp/pids/unicorn.#{application}.pid"

working_directory current_path

stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{current_path}/Gemfile"
end
