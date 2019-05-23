# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1604"
  config.vm.box_version = "= 1.9.12"

  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.provision "docker" 
    docker.vm.provision "file", 
      source: "provisioning/flask_app/", 
      destination: "/home/vagrant/"
    docker.vm.provision "file", 
      source: "provisioning/flask_nginx/", 
      destination: "/home/vagrant/"
    docker.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/docker_provision.sh"
    docker.vm.network :private_network, ip: "172.28.33.10"
    docker.vm.provider :virtualbox do |vb|
      vb.cpus = 1
      vb.memory = 1024
    end
  end

  config.vm.define "openshift" do |openshift|
    openshift.vm.hostname = "openshift"
    openshift.vm.provision "docker" 
    openshift.vm.provision "file", 
      source: "provisioning/flask_nginx/", 
      destination: "/home/vagrant/"
    openshift.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/openshift_provision.sh", 
      run:"always"
    openshift.vm.network :private_network, ip: "172.28.33.20"
    openshift.vm.provider :virtualbox do |vb|
      vb.cpus = 4
      vb.memory = 4096
    end
  end

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.provision "docker" 
    jenkins.vm.provision "file",
      source: "provisioning/jenkins_init.groovy",
      destination: "~/jenkins_init.groovy"
    jenkins.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/jenkins_provision.sh"
    jenkins.vm.network :private_network, ip: "172.28.33.30"
    jenkins.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end
  end

end
