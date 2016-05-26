Vagrant.configure('2') do |config|
  config.vm.hostname = 'odoo-demo.odoogroup.com'
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    provider.token = ''
    provider.image = 'ubuntu-14-04-x64'
    provider.region = 'ams3'
    provider.size = '512mb'
  end
end
