require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/unicorn"
load "config/recipes/check"

set :gateway, "pbruna@gorgory.itlinux.cl"

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