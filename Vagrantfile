VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-18.10"
  config.vm.provider "virtualbox" do |vb|
     vb.cpus = 1
     vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #config.vm.provision "shell", path: "setup.sh"
  #config.vm.provision :reload
end
