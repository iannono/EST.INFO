# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'estao'
set :repo_url, 'git@github.com:xiongbo/EST.INFO.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :user, "estao"
# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :use_sudo, false

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/pd_images public/en_images}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5
set :rails_env, 'production'
set :deploy_via, :remote_cache
set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

# for whenever
set :whenever_command, [:bundle, :exec, :whenever]
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  desc "Start Application"
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :bundle, "exec unicorn_rails", "-c", fetch(:unicorn_config_path), "-E production -D"
      end
    end
  end

  desc "Stop Application"
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "kill -QUIT `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
    end
  end

  desc "Restart Application"
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      execute "kill -USR2 `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
    end
  end

  desc "Start or Restart Application"
  task :start_or_restart do
    on roles(:app), in: :sequence, wait: 10 do
      if test "[ -f #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid ]"
        execute "kill -USR2 `cat #{shared_path}/tmp/pids/unicorn.#{fetch(:application)}.pid`"
      else
        within current_path do
          execute :bundle, "exec unicorn_rails", "-c", fetch(:unicorn_config_path), "-E production -D"
        end
      end
    end
  end

  after :publishing, :start_or_restart
  after :finishing, :cleanup

  desc "Init the config files in shared_path"
  task :setup_config do
    on roles(:app), in: :sequence, wait: 5 do
      unless test "[ -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
        upload!("config/database.yml.example", "#{shared_path}/config/database.yml")
        upload!("config/application.yml", "#{shared_path}/config/application.yml")
        puts "Now edit the config files in #{shared_path}"
      end
    end
  end
  after "check:directories", :setup_config

  desc "Populates the Production Database"
  task :seed do
    on roles(:db), in: :sequence, wait: 5 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          rake 'db:seed'
        end
      end
    end
  end
end

# for delayed job
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
after 'deploy:publishing', 'deploy:restart'
