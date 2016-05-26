define odoo::instance (

  Integer $port = 8069,
  String $username,
  String $groupname,
  $template='/vagrant/modules/odoo/templates/odoo.conf.erb',

  ) {

  include nginx

  file {'/opt/odoo': 
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    ensure => directory,
  }

  file { "/opt/odoo/${name}":
    owner   => $username,
    group   => $groupname,
    mode    => '0700',
    require => File['/opt/odoo'],
  }
  
  file { "/opt/odoo/${name}/.openerp-serverrc":
    content => template($template),
    owner   => $username,
    group   => $groupname,
    mode    => '0700',
    require => File["/opt/odoo/${name}"],
  }

  vcsrepo { "/opt/odoo/${name}":
    ensure   => present,
    provider => git,
    source   => $odoo::odoo_repo_url,
    revision => $odoo::branch,
    identity => $odoo::gitsshkey,
    user     => $odoo::odoo_repouser,
  }

  if $odoo::manage_packages {
    ensure_packages($odoo::dependency_packages)
  }

  wget::fetch { 'wkhtmltox':
    source      => 'http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    destination => '/tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    timeout     => 900,
    require     => Package[$odoo::dependency_packages],
  }

  package { 'wkhtmltox':
    source   => '/tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    provider => 'dpkg',
    require  => Wget::Fetch['wkhtmltox'],
  }

  exec { 'odoo_pip_requirements_install':
    command => "/usr/bin/pip install -r /opt/odoo/${name}/requirements.txt",
    require => Vcsrepo["/opt/odoo/${name}"],
    timeout => 900,
  }

  nginx::resource::vhost { "${name}":
    listen_port => 80,
    proxy       => "http://localhost:${port}",
    }

}
  
