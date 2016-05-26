define odoo::instance (
  
  Integer $port,
  String $username,
  String $groupname,
  String $sitename,
  $template='/vagrant/modules/odoo/templates/odoo.conf.erb',
  
  ) {
  
  include nginx
  include odoo::params
  
  file {'/opt/odoo':
    owner  => 'root',
    group  => 'root',
    mode   => '0777',
    ensure => directory,
  }
  
  file { "/opt/odoo/${name}":
    owner   => $username,
    group   => $groupname,
    mode    => '0777',
    require => File['/opt/odoo'],
  }
  
  file { "/opt/odoo/${name}/.openerp-serverrc":
    content => template($template),
    owner   => $username,
    group   => $groupname,
    mode    => '0777',
    require => File["/opt/odoo/${name}"],
  }
  
  vcsrepo { "/opt/odoo/${name}":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/odoo/odoo.git',
    revision => '8.0',
    user     => 'root',
    require  => File['/opt/odoo'],
  }
  
  wget::fetch { 'wkhtmltox':
    source      => 'http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    destination => '/tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    timeout     => 900,
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
  
  user { "${username}":
    ensure  => 'present',
    home    => "/opt/odoo/${name}",
    groups  => "${groupname}",
    shell   => '/bin/bash',
    require => Group["${groupname}"],
  }
  
  group { "${groupname}":
    ensure => 'present',
  }

  exec { "odoo_db_init_${name}":
    command => "/opt/odoo/${name}/openerp-server --init=all --addons-path=/opt/odoo/${name}/addons --stop-after-init -r ${username} -w ${username} -d ${username} --without-demo=True --timezone=\"Europe/Helsinki\" --no-database-list --load-language=\"fi_FI\"  --db-filter=${name}",
    require => Exec['odoo_pip_requirements_install'],
    user => "${username}",
    timeout => 900,
  }
  
  postgresql::server::db { "${username}":
    user     => "${username}",
    password => postgresql_password("${username}", "${username}"),
    before => Exec["odoo_db_init_${name}"],
  }

}
  
