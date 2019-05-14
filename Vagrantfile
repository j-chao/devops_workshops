# -*- mode: ruby -*-
# vi: set ft=ruby : 
Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  config.vm.box = "generic/ubuntu1604"
  config.vm.box_version = "= 1.9.12"

  config.vm.define "local" do |local|
      local.vm.hostname = "local"
      local.vm.provision :shell, privileged: false, path:  "provision.sh"
      local.vm.network :private_network, ip: "172.28.33.11"
  end
  config.vm.define "openshift" do |openshift|
      openshift.vm.hostname = "openshift"
      openshift.vm.network :private_network, ip: "172.28.33.12"
  end
  config.vm.define "jenkins" do |jenkins|
      jenkins.vm.hostname = "jenkins"
      jenkins.vm.network :private_network, ip: "172.28.33.13"
  end


  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  #config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"

  # config.vm.network "public_network"

  # config.vm.synced_folder "../data", "/vagrant_data"


  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get -y update
  SHELL

  config.vm.provision "docker"
  
end

    #sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
    #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    #sudo apt-get -y update

    #sudo apt-cache policy docker-ce
    #sudo apt-get -y install docker-ce

    #sudo usermod -aG docker vagrant
