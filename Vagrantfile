# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1604"
  config.vm.box_version = "= 1.9.12"

  config.vm.define "docker" do |docker|
      docker.vm.hostname = "docker"
      docker.vm.provision "docker" 
      docker.vm.provision :shell, privileged: false, path: "docker_provision.sh"
      docker.vm.provision "file", source: "./00_containers/flask_app/", destination: "/home/vagrant/"
      docker.vm.network :private_network, ip: "172.28.33.10"
      docker.vm.provider :virtualbox do |vb|
        vb.cpus = 1
        vb.memory = 1024
      end
  end
  config.vm.define "openshift" do |openshift|
      openshift.vm.hostname = "openshift"
      openshift.vm.provision "docker" 
      openshift.vm.provision :shell, privileged: false, path: "provision.sh"
      openshift.vm.network :private_network, ip: "172.28.33.11"
      openshift.vm.provider :virtualbox do |vb|
        vb.cpus = 2
        vb.memory = 2048
      end
  end
  config.vm.define "pipeline" do |jenkins|
      jenkins.vm.hostname = "pipeline"
      jenkins.vm.network :private_network, ip: "172.28.33.12"
      local.vm.provider :virtualbox do |vb|
        vb.cpus = 1
        vb.memory = 1024
      end
  end

end
