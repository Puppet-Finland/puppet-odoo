Vagrant.configure('2') do |config|
  config.vm.hostname = 'odoo-demo.odoogroup.com'
  config.vm.provision "shell", path: "provision/bootstrap_agent.sh"
  config.vm.provision "shell", path: "provision/bootstrap_odoo.sh"
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    provider.token = '60f0f43fb2e92a3e826944f50cc9624b602f741a2a8991c1c77ac70f984e5060'
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'ams3'
    provider.size = '512mb'
  end
end
