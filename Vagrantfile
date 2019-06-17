# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1604"
  config.vm.box_version = "= 1.9.12"

  config.vm.define "docker-vm" do |docker-vm|
    docker-vm.vm.hostname = "docker-vm"
    docker-vm.vm.provision "docker" 
    docker-vm.vm.provision "file", 
      source: "example_apps_devops/flask_app/", 
      destination: "/home/vagrant/"
    docker-vm.vm.provision "file", 
      source: "example_apps_devops/flask_nginx/", 
      destination: "/home/vagrant/"
    docker-vm.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/docker_provision.sh"
    docker-vm.vm.network :private_network, ip: "172.28.33.10"
    docker-vm.vm.provider :virtualbox do |vb|
      vb.cpus = 1
      vb.memory = 1024
    end
  end

  config.vm.define "openshift-vm" do |openshift-vm|
    openshift-vm.vm.hostname = "openshift-vm"
    openshift-vm.vm.provision "docker" 
    openshift-vm.vm.provision "file", 
      source: "example_apps_devops/flask_app/", 
      destination: "/home/vagrant/"
    openshift-vm.vm.provision "file", 
      source: "example_apps_devops/flask_nginx/", 
      destination: "/home/vagrant/"
    openshift-vm.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/openshift_provision.sh", 
      run:"always"
    openshift-vm.vm.network :private_network, ip: "172.28.33.20"
    openshift-vm.vm.provider :virtualbox do |vb|
      vb.cpus = 4
      vb.memory = 4096
    end
  end

  config.vm.define "jenkins-vm" do |jenkins-vm|
    jenkins-vm.vm.hostname = "jenkins-vm"
    jenkins-vm.vm.provision "docker" 
    jenkins-vm.vm.provision "file",
      source: "provisioning/jenkins_init/",
      destination: "/home/vagrant/"
    jenkins-vm.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/jenkins_provision.sh"
    jenkins-vm.vm.network :private_network, ip: "172.28.33.30"
    jenkins-vm.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end
  end

end
