require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/unicorn"
load "config/recipes/check"

set :gateway, "pbruna@gorgory.itlinux.cl"

##########################################################
# Configuration for delayed_job
require "delayed/recipes"
set :rails_env, "production"
set :delayed_job_args, "-n 2"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
##########################################################

server "console.carterapp.com", :web, :app

set :application, "CarterApp"
set :user, "carter"
set :deploy_to, "/home/#{user}/App/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :ssh_options, {:forward_agent => true}

set :scm, "git"
set :repository,  "git://github.com/pbruna/#{application}.git"
set :branch, "master"
set :bundle_flags, "--deployment --quiet --binstubs"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases