# config valid only for current version of Capistrano
lock '3.6.1'

set :application, "vodovoz"
set :repo_url, "git@github.com:Wolfnet83/Vodovoz.git"

set :user, "deployer"
set :deploy_to, "/home/deployer/vodovoz"
set :linked_files, %w{config/database.yml config/ldap.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}



# after "deploy:finalize_update", "deploy:symlink_config"
#
# namespace :deploy do
#   task :symlink_config do
#     run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
#     run "ln -nfs #{shared_path}/ldap.yml #{release_path}/config/ldap.yml"
#   end
# end
