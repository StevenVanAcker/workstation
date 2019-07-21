VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-19.04"
  config.vm.provider "virtualbox" do |vb|
     vb.cpus = 4
     vb.customize ["modifyvm", :id, "--memory", "4096"]
	 vb.gui = true
  end
  config.vm.provision "shell", inline: "apt-get update && apt-get install -y ubuntu-desktop bash-completion git"
  config.vm.provision :reload
end
