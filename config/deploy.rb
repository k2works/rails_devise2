require 'bundler/capistrano'
load 'deploy/assets'

set :application, "device2"
set :deploy_to, "/var/rails/devise2"
set :user, "rails"
set :use_sudo, false

set :repository, "git@github.com:k2works/devise2.git"
set :branch, "master"
set :scm, :git
set :deploy_via, :remote_cache

set :normalize_asset_timestamps, false
set :keep_releases, 3

role :web, "demo.k2-works.net"
role :app, "demo.k2-works.net"
role :db, "demo.k2-works.net", :primary => true

after "deploy:update", :roles => :app do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/"
end

after "deploy:migrate", "deploy:update", "deploy:cleanup"

namespace :deploy do
  desc "Restarts your application."
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

