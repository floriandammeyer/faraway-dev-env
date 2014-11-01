Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"

  config.vm.provision :shell, path: "vagrant-up/bootstrap.sh"

  # Make the webserver and the MySQL server accessible to the host
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  # HTTP port for accessing mailcatcher's inbox
  config.vm.network :forwarded_port, guest: 1080, host: 1080
end
