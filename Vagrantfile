# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # define master
  config.vm.define "master" do |master|
    master.vm.box = "../centos7.box"
    master.vm.hostname = 'master'
    master.vm.network :private_network, ip: "192.168.99.101"
    master.vm.network "forwarded_port", guest: 6443, host: 6443
    master.vm.network "forwarded_port", guest: 8001, host: 8001
    master.vm.provision "shell", inline: "swapoff -a"
    master.vm.synced_folder ".", "/vagrant"

    master.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.memory = 3096
      v.cpus = 2
      v.customize ["modifyvm", :id, "--name", "master"]
    end

    master.vm.provision "shell", path: "install_k8s.sh"
    master.vm.provision "shell", path: "configure_master.sh"
  end

end