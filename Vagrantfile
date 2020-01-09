# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu1804"

  config.vm.define "docker" do |docker|
    docker.vm.box_version = "= 2.0.6"
    docker.vm.hostname = "docker"
    docker.vm.provision "docker" 
    docker.vm.provision "file", 
      source: "example_apps_devops/flask_app/", 
      destination: "/home/vagrant/"
    docker.vm.provision "file", 
      source: "example_apps_devops/flask_nginx/", 
      destination: "/home/vagrant/"
    docker.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/docker_provision.sh"
    docker.vm.network :private_network, ip: "172.28.33.10"
    docker.vm.provider :virtualbox do |vb|
      vb.cpus = 0.5
      vb.memory = 512
    end
  end

  config.vm.define "openshift" do |openshift|
    openshift.vm.box_version = "= 2.0.6"
    openshift.vm.hostname = "openshift"
    openshift.vm.provision "docker" 
    openshift.vm.provision "file", 
      source: "example_apps_devops/flask_app/", 
      destination: "/home/vagrant/"
    openshift.vm.provision "file", 
      source: "example_apps_devops/flask_nginx/", 
      destination: "/home/vagrant/"
    openshift.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/openshift_provision.sh", 
      run:"always"
    openshift.vm.network :private_network, ip: "172.28.33.20"
    openshift.vm.provider :virtualbox do |vb|
      vb.cpus = 2
      vb.memory = 2048
    end
  end

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box_version = "= 2.0.6"
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.provision "docker" 
    jenkins.vm.provision "file",
      source: "provisioning/jenkins_init/",
      destination: "/home/vagrant/"
    jenkins.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/jenkins_provision.sh"
    jenkins.vm.network :private_network, ip: "172.28.33.30"
    jenkins.vm.provider :virtualbox do |vb|
      vb.cpus = 1
      vb.memory = 1024
    end
  end

  config.vm.define "kubernetes" do |kubernetes|
    kubernetes.vm.box_version = "= 2.0.6"
    kubernetes.vm.hostname = "kubernetes"
    kubernetes.vm.provision "file", 
      source: "example_apps_devops/kubernetes/", 
      destination: "/home/vagrant/"
    kubernetes.vm.provision "file", 
      source: "provisionin/optum_certs/", 
      destination: "/usr/local/share/ca-certificates/"
    kubernetes.vm.provision :shell, 
      privileged: true, 
      path: "provisioning/kubernetes_provision.sh"
    kubernetes.vm.network "private_network", ip: "172.28.33.40"
    kubernetes.vm.provider :virtualbox do |vb| 
      vb.cpus = 2
      vb.memory = 2048
    end
  end

  config.vm.define "k8s" do |k8s|
    k8s.vm.box_version = "= 2.0.6"
    k8s.vm.hostname = "k8s"
    k8s.vm.provision "file", 
      source: "example_apps_devops/efk_stack/", 
      destination: "/home/vagrant/"
    k8s.vm.provision :shell, 
      privileged: false, 
      path: "provisioning/kubernetes_provision.sh"
    k8s.vm.network "private_network", ip: "172.28.33.50"
    k8s.vm.provider :virtualbox do |vb| 
      vb.cpus = 2
      vb.memory = 2048
    end
  end

end
