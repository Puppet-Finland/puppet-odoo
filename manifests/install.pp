# == Class: odoo::install
#
class odoo::install inherits odoo::params {

  include stdlib

  group { $::odoo::params::odoo_group:
    ensure      => present,
  }

  user { $::odoo::params::odoo_user:
    ensure     => present,
    managehome => true,
    name       => $::odoo::params::odoo_user,
    require    => Group['Odoo group'] 
  }
  
  file { $::odoo::params::install_path:
    ensure      => directory,
    owner       => $::odoo::params::odoo_user,
    mode        => '0644',
    require => User[$::odoo::params::odoo_user] 
  }

  vcsrepo { $::odoo::params::install_path:
    ensure      => present,
    provider    => git,
    source      => $::odoo::params::odoo_repo_url,
    revision    => $::odoo::params::version,
    identity    => $::odoo::params::gitsshkey,
    user        => $::odoo::params::odoo_user,
    depth       => '1',
    require     => File[$::odoo::params::install_path],
  }

  ensure_packages($odoo::params::dependency_packages)

  package { 'psycogreen':
    ensure      => $::odoo::params::psycogreen_version,
    provider    => pip,
  }

  wget::fetch { 'wkhtmltox':
    source      => $::odoo::params::wkhtmltox_source,
    destination => '/tmp/wkhtmltox.deb',
    unless      => 'test -f /tmp/wkhtmltox.deb',
    timeout     => 900,
  }

  package { 'wkhtmltox':
    source      => '/tmp/wkhtmltox.deb',
    provider    => 'dpkg',
    require     => Wget::Fetch['wkhtmltox'],
  }
  
  exec { 'odoo_pip_requirements_install':
    command     => "/usr/bin/pip install -r ${::odoo::params::install_path}/requirements.txt",
    require     => Vcsrepo[$odoo::params::install_path],
    timeout     => 900,
  }

}
