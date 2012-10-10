# encoding: utf-8
namespace :carter do

  desc "Setup Admin Account and User"
  task :create_admin_account => :environment do
    if Account.any_root_account?
      puts "Ya existe una cuenta root"
    else
      print "Ingrese nombre de la cuenta: "
      account_name = STDIN.gets.chomp
      print "Ingrese su email: "
      email = STDIN.gets.chomp
      print "Ingrese su contraseña: "
      system "stty -echo"
      password = STDIN.gets.chomp
      print "\nConfirme su contraseña: "
      password_confirmation = STDIN.gets.chomp
      system "stty echo"
      print "\n"
      account = Account.new(:name => account_name, :root => true)
      user = account.users.build(:email => email, :password => password, :password_confirmation => password_confirmation)
      if account.save
        puts "Cuenta creado"
      else
        puts "No se pudo crear la cuenta: #{account.errors.full_messages.join(", ")}"
      end
    end
  end

end
