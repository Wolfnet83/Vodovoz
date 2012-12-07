require 'capistrano_colors'
require 'bundler/capistrano'

set :application, "vodovoz"
set :repository, "git@github.com:Wolfnet83/Vodovoz.git"
set :branch, "master"
server "10.0.0.222", :web, :app, :db, :primary => true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "deployer"

set :deploy_to, "/home/deployer/#{application}"
set :deploy_via, :export

set :use_sudo, false

#role :web, Apache # Your HTTP server, Apache/etc
#role :app, server # This may be the same as your `Web` server
#role :db, server, :primary => true # This is where Rails migrations will run

# set :rake, "#{rake} --trace"

after "deploy", "deploy:cleanup" # keep only the last 5 releases
#after "deploy:update_code", "deploy:migrate"
after "deploy:finalize_update", "deploy:symlink_config"

namespace :deploy do
  task :symlink_config do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/ldap.yml #{release_path}/config/ldap.yml"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "Tail production log files"
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    trap ("INT") { puts "\nInterrupded"; exit 0; }
    puts
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end
