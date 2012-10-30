set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{shared_path}/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
set_default(:unicorn_error_log) { "#{shared_path}/log/unicorn_error.log" }
set_default(:unicorn_port, 8080)
set_default(:unicorn_workers, 2)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "#{application}_init.erb", "/tmp/#{application}_init"
    run "chmod +x /tmp/#{application}_init"
    run "#{sudo} mv /tmp/#{application}_init /etc/init.d/#{application}"
    run "#{sudo} chkconfig --add #{application}"
    run "ln -fs #{shared_path}/config/mongoid.yml #{current_path}/config/"
    run "ln -fs #{shared_path}/config/initializers/smtp_config.rb #{current_path}/config/initializers/smtp_config.rb"
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "service #{application} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end