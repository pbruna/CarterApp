def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :carterapp do
  desc "Copy configuration files for CarterApp"
  task :setup do
    run "ln -fs #{shared_path}/config/mongoid.yml #{current_path}/config/"
    run "ln -fs #{shared_path}/config/initializers/smtp_config.rb #{current_path}/config/initializers/smtp_config.rb"
  end
  after "deploy", "carterapp:setup"
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "echo 'Nothing to install for the moment'"
  end
end