# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  
  config.vm.provision "docker"
  
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update
    sudo apt install python3-pip -y
    pip install virtualenv
    pip install setuptools
  SHELL
  
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 6144
  end

  config.vm.network "public_network"

  config.vm.provision "shell", inline: <<-SHELL
    hostname -I
  SHELL
end
