Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = "ubuntu/jammy64"
    jenkins.vm.network "forwarded_port", guest: 8080, host: 8080
    jenkins.vm.network "private_network", type: "dhcp"

    jenkins.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.cpus = 2
      vb.memory = "1024"
      vb.name = "jenkins"
    end

    jenkins.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
    end
  end

  config.vm.define "instance1" do |instance1|
    instance1.vm.box = "ubuntu/xenial64"  
    instance1.vm.network "private_network", type: "dhcp"

    instance1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.cpus = 2
      vb.memory = "1024"
      vb.name = "instance1"
    end
  end
end