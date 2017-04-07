# == Class: odoo::install
#
# Full description of class odoo here.

class odoo::install inherits odoo::params {

  include stdlib

  vcsrepo { $::odoo::params::install_path:
    ensure   => present,
    provider => git,
    source   => $::odoo::params::odoo_repo_url,
    revision => $::odoo::params::branch,
    identity => $::odoo::params::gitsshkey,
    user     => $::odoo::params::odoo_repouser,
    depth    => '1',
  }

  ensure_packages($odoo::dependency_packages)

  package { 'psycogreen':
    ensure  => installed,
    version => $::odoo::params::psycogreen_version,
    provide => pip,
  }

  wget::fetch { 'wkhtmltox':
    source      => $::odoo::params::wkhtmltox_source,
    destination => '/tmp/wkhtmltox.deb',
    unless      => 'test -f /tmp/wkhtmltox.deb',
    timeout     => 900,
  }

  package { 'wkhtmltox':
    source   => '/tmp/wkhtmltox.deb',
    provider => 'dpkg',
    require  => Wget::Fetch['wkhtmltox'],
  }
  
  exec { 'odoo_pip_requirements_install':
    command => "/usr/bin/pip install -r ${odoo::install_path}/requirements.txt",
    require => Vcsrepo[$odoo::install_path],
    timeout => 900,
  }

}
