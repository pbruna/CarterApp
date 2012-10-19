worker_processes 4
working_directory Dir.pwd
listen 8080, :tcp_nopush => true
pid "#{root_path}/tmp/unicorn.pid"
stderr_path "#{root_path}/log/unicorn_error.log"
stdout_path "#{root_path}/log/unicorn.log"
timeout 30
preload_app true