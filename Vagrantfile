# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = false

  config.vm.define "buster", primary: false, autostart: false do |box|
    box.vm.box = "debian/buster64"
    box.vm.box_version = "10.4.0"
    box.vm.hostname = 'buster.local'
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.hostmanager.manage_guest = true
    box.hostmanager.aliases = %w(buster)
    box.vm.network "forwarded_port", guest: 8069, host: 8069
    box.vm.provider 'virtualbox' do |vb|
      vb.linked_clone = true
      vb.gui = false
      vb.memory = 1024
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/install_agent.sh"
    end
    box.vm.provision "shell" do |s|
      s.path = "vagrant/run_puppet.sh"
      s.args = ["-b", "/vagrant", "-m", "prepare.pp odoo.pp" ]
    end
  end
end
