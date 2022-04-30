# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.boot_timeout = 1000

  # Fixes changes from https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 16384]
    vb.customize ["modifyvm", :id, "--cpus", 4]
  end

  config.disksize.size='100GB'

#  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.define :h2 do |h2|
    h2.vm.hostname="h2.local.com"
    h2.vm.network :private_network, ip: "192.168.57.101"
#
  end

  config.vm.define :h3 do |h3|
    h3.vm.hostname="h3.local.com"
    h3.vm.network :private_network, ip: "192.168.57.102"
#
  end

end
