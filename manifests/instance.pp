define odoo::instance (
  
  String $basedir,
  Integer $port,
  String $username,
  String $groupname,
  String $sitename,
  String $Branch,
  
)
{
  
  include odoo::params
  
  # Do not use pip from packages
  # see https://bugs.launchpad.net/fuel/+bug/1547048
  package { 'python-pip':
    ensure => 'absent',
  }

  package { 'python-setuptools':
    ensure => 'present',
  }

  exec { 'install-pip':
    command => '/usr/bin/easy_install pip',
    creates => '/usr/local/bin/pip',
    require => [
      Package['python-pip'],
      Package['python-setuptools'],
    ]
  }

   file { $basedir:
    owner  => 'root',
    group  => 'root',
    mode   => '0777',
    ensure => directory,
  }
  
  file { "${basedir}/${title}":
    owner   => $username,
    group   => $groupname,
    mode    => '0777',
    require => File[$basedir],
  }

  file { "$basedir/${title}/bin":
    ensure => directory,
    owner   => $sername,
    group   => $groupname,
    mode    => '0600',
  }

  group { $groupname:
    ensure => present,
  }
  
  user { $username:
    ensure  => present,
    home    => "$basedir/${title}",
    require => [
      Group[$groupname],
      File["$basedir/${title}"],
    ]
  }

  $scripts = $::odoo::params::scripts

  $scripts.each |$script| {
    file { "$basedir/${title}/bin/${script}":
      owner   => $user,
      group   => $group,
      mode    => '0700',
      content => template("odoo/${script}.erb"),
      require => File["$basedir/${title}/bin"],
    }
  }

  file { "/opt/odoo/${title}/.openerp-serverrc":
    owner   => $username,
    group   => $groupname,
    mode    => '0777',
    content => template('odoo/odoo.conf.erb'),
    require => File["$basedir/${title}"],
  }
  
  vcsrepo { "$basedir/${title}":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/odoo/odoo.git',
    revision => $branch,
    user     => 'root',
    depth    => '1',
    require  => File[$basedir],
  }
  
  wget::fetch { 'wkhtmltox':
    source      => 'http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb',
    destination => '/tmp/wkhtmltox.deb',
    timeout     => 900,
  }
  
  package { 'wkhtmltox':
    source   => '/tmp/wkhtmltox.deb',
    provider => 'dpkg',
    require  => Wget::Fetch['wkhtmltox'],
  }
  
  exec { 'odoo_pip_requirements_install':
    command => "/usr/bin/pip install -r /opt/odoo/${name}/requirements.txt",
    require => Vcsrepo["/opt/odoo/${title}"],
    timeout => 900,
  }
  
  user { "${username}":
    ensure  => 'present',
    home    => "$basedir/${title}",
    groups  => "${groupname}",
    shell   => '/bin/bash',
    require => Group["${groupname}"],
  }
  
  group { "${groupname}":
    ensure => 'present',
  }

  ensure_packages($odoo::params::dependency_packages)

  postgresql::server::db { "${username}":
    user     => "${username}",
    password => postgresql_password("${username}", "${username}"),
    before   => Exec["Initialize ${title} database"],
  }

  exec { "Initialize ${title} database":
    command => "${basename}/initdb",
    path    => [ '/usr/bin', '/bin', '/usr/sbin' '/usr/local/bin' ],
    user    => 'root',
    unless  => "${basedir}/testdb", 
    require => File["${basedir}/testdb"],
  }


}
  
